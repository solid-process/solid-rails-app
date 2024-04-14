# frozen_string_literal: true

module User::Password
  MINIMUM_LENGTH = 8

  VALIDATIONS = {presence: true, length: {minimum: MINIMUM_LENGTH}}

  VALIDATIONS_WITH = -> { VALIDATIONS.merge(_1) }

  VALIDATIONS_WITH_CONFIRMATION = VALIDATIONS_WITH[confirmation: true]
end
