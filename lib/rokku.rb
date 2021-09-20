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
    # Example: redirect_to "/" unless authorized?("post", create")

    def authorized?(controller, action)
      input_roles = @user.roles
      roles = []
      if input_roles.class == String
        roles << input_roles
      else
        roles = input_roles
      end
      Object.const_get(controller.downcase.capitalize + "Policy").new(roles).send("#{action.downcase}?")
    end
  end
end

::Hanami::Controller.configure do
  prepare do
    include Hanami::Rokku
  end
end
