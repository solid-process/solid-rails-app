# frozen_string_literal: true

class User::Registration < Solid::Process
  deps do
    attribute :mailer, default: UserMailer
    attribute :repository, default: User::Repository
    attribute :token_creation, default: User::Token::Creation
    attribute :task_list_creation, default: Account::Task::List::Creation

    validates :repository, respond_to: [:exists?, :create!, :create_account!]
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
        .and_then(:create_user_inbox)
        .and_then(:create_user_token)
    }
      .and_then(:send_email_confirmation)
      .and_expose(:user_registered, [:user])
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
    result = deps.repository.create_account!(user:)

    Continue(account: result[:account])
  end

  def create_user_inbox(account:, **)
    case deps.task_list_creation.call(account:, inbox: true)
    in Solid::Success(task_list:) then Continue()
    end
  end

  def create_user_token(user:, **)
    case deps.token_creation.call(user:)
    in Solid::Success(token:) then Continue()
    end
  end

  def send_email_confirmation(user:, **)
    deps.mailer.with(
      user:,
      token: user.generate_token_for(:email_confirmation)
    ).email_confirmation.deliver_later

    Continue()
  end
end
