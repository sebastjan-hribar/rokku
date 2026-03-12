require 'rokku/version'

module Hanami
  module Rokku
    private

    # ### Authorization ###
    # The authorized? method checks if the specified user has the required role
    # and permission to access the action. It returns true or false and
    # provides the basis for further actions in either case.
    #
    # Example: redirect_to "/" unless authorized?("testapp", "posts", create")

    def authorized?(application, resource, action, user)
      input_roles = user.roles
      roles = []
      if input_roles.class == String
        roles << input_roles
      else
        roles = input_roles
      end
      Object.const_get("#{application}::#{resource.downcase.capitalize}Policy").new(roles).send("#{action.downcase}?")
    end
  end
end