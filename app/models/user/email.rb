# frozen_string_literal: true

module User::Email
  REGEXP = URI::MailTo::EMAIL_REGEXP

  VALIDATIONS = {presence: true, format: {with: REGEXP}}

  VALIDATIONS_WITH = -> { VALIDATIONS.merge(_1) }

  NORMALIZATION = -> { _1.downcase.strip }
end
