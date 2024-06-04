# frozen_string_literal: true

module User
  extend Solid::Context

  import(token: Token)

  self.actions = {
    register: Registration,
    authenticate: Authentication,
    delete_account: AccountDeletion,
    reset_password: Password::Resetting,
    update_password: Password::Updating,
    send_reset_password_instructions: Password::SendingResetInstructions
  }

  def repository = Adapters.repository
end
