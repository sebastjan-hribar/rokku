require 'rokku/version'
require 'hanami/controller'

module Hanami
  module Rokku
    private

    # ### Authorization ###
    # The authorized? method checks if the specified user has the required role
    # and permission to access the action. It returns true or false and
    # provides the basis for further actions in either case.
    #
    # Example: redirect_to "/" unless authorized?("PostController", "admin", "create")

    def authorized?(controller, role, action)
      Object.const_get(controller.downcase.capitalize + "Policy").new(role).send("#{action.downcase}?")
    end
  end
end

::Hanami::Controller.configure do
  prepare do
    include Hanami::Rokku
  end
end
