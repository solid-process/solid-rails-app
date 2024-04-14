# frozen_string_literal: true

class User::Password::Resetting < Solid::Process
  input do
    attribute :token, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    validates :token, presence: true
    validates :password, User::Password::VALIDATIONS_WITH_CONFIRMATION
  end

  def call(attributes)
    Given(attributes)
      .and_then(:find_user_by_token)
      .and_then(:update_user_password)
      .and_expose(:password_updated, [:user])
  end

  private

  def find_user_by_token(token:, **)
    user = User.find_by_reset_password(token:)

    user ? Continue(user:) : Failure(:user_not_found)
  end

  def update_user_password(user:, password:, password_confirmation:, **)
    return Continue() if user.update(password:, password_confirmation:)

    input.errors.merge!(user.errors)

    Failure(:invalid_input, input:)
  end
end
