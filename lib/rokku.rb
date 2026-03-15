require 'rokku/version'

module Hanami
  module Rokku
    private

    # ### Authorization ###
    # The authorized? method checks if the specified user has the required role
    # and permission to access the action. It returns true or false and
    # provides the basis for further actions in either case.
    #
    # There are 2 modes of arguments specification possible: automatic and manual.
    # Automatic would fit most cases. With manual it would be possible to do
    # cross-namespace authorization checks and multiple permission checks.

    # Automatic
    #   authorized?(user: current_user)
    #
    # Manual
    #   authorized?(user: current_user, namespace: "ChessBase", resource: "EndGames", action: "destroy")
    #
    # The namespace argument can either be the main application name or s slice name.

    def authorized?(user, namespace: nil, resource: nil, action: nil)
      if namespace.nil? || resource.nil? || action.nil?
        namespace = self.class.to_s.split("::")[0]
        resource = self.class.to_s.split("::")[2]
        action = self.class.to_s.split("::")[3]
      end

      input_roles = user.roles
      roles = input_roles.is_a?(String) ? [input_roles] : input_roles
            
      Object.const_get("#{namespace}::#{resource}Policy").new(roles).send("#{action.downcase}?")
    end
  end
end