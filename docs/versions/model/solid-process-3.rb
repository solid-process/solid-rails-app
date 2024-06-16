class User::Registration < Solid::Process
  deps do
    attribute :token_creation, default: User::Token::Creation
    attribute :account_creation, default: Account::Member::OwnerCreation

    attribute :mailer, default: -> { User::Adapters.mailer }
    attribute :repository, default: -> { User::Adapters.repository }
    attribute :temporary_token, default: -> { User::Adapters.temporary_token }

    validates :mailer, respond_to: [:send_email_confirmation]
    validates :repository, respond_to: [:create!, :exists?]
    validates :temporary_token, respond_to: [:to]
  end

  input do
    attribute :uuid, :string, default: -> { ::UUID.generate }
    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    before_validation do
      self.email = email.downcase.strip
    end

    with_options presence: true do
      validates :uuid, format: ::UUID::REGEXP
      validates :email, format: User::Email::REGEXP
      validates :password, confirmation: true, length: {minimum: User::Password::MINIMUM_LENGTH}
    end
  end

  def call(attributes)
    rollback_on_failure {
      Given(attributes)
        .and_then(:check_if_email_is_taken)
        .and_then(:create_user)
        .and_then(:create_user_account)
        .and_then(:create_user_token)
    }
      .and_then(:send_email_confirmation)
      .and_expose(:user_registered, [:user, :user_token])
  end

  private

  def check_if_email_is_taken(email:, **)
    input.errors.add(:email, "has already been taken") if deps.repository.exists?(email:)

    input.errors.any? ? Failure(:invalid_input, input:) : Continue()
  end

  def create_user(uuid:, email:, password:, password_confirmation:, **)
    case deps.repository.create!(uuid:, email:, password:, password_confirmation:)
    in Solid::Success(user:) then Continue(user:)
    in Solid::Failure(user:)
      input.errors.merge!(user.errors)

      Failure(:invalid_input, input:)
    end
  end

  def create_user_account(user:, **)
    case deps.account_creation.call(uuid: user.uuid)
    in Solid::Success then Continue()
    end
  end

  def create_user_token(user:, **)
    case deps.token_creation.call(user:)
    in Solid::Success(token:) then Continue(user_token: token.value)
    end
  end

  def send_email_confirmation(user:, **)
    token = deps.temporary_token.to(:email_confirmation, user)

    deps.mailer.send_email_confirmation(token:, email: user.email)

    Continue()
  end
end
