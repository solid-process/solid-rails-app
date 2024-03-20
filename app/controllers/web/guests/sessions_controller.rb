# frozen_string_literal: true

module Web::Guests
  class SessionsController < BaseController
    def new
      render("web/guest/sessions/new", locals: {user: User.new})
    end
  end
end
