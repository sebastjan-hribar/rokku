require 'fileutils'

require 'hanami/controller'
require 'hanami/action/session'

module Hanami
  module Rokku
    private
# The generate_policy method creates the policy file for specified
# application and controller. By default all actions to check against
# are commented out.
# Uncomment the needed actions and define appropriate user roles.

def generate_policy(app_name, controller_name)
  app_name = app_name
  controller = controller_name.downcase.capitalize
  policy_txt = <<-TXT
    class #{controller}Policy
      def initialize(roles)
        @user_roles = roles
        # Uncomment the required roles and add the
        # appropriate user role to the @authorized_roles* array.
        # @authorized_roles_for_new = []
        # @authorized_roles_for_create = []
        # @authorized_roles_for_show = []
        # @authorized_roles_for_index = []
        # @authorized_roles_for_edit = []
        # @authorized_roles_for_update = []
        # @authorized_roles_for_destroy = []
      end

      def new?
        (@authorized_roles_for_new & @user_roles).any?
      end

      def create?
        (@authorized_roles_for_create & @user_roles).any?
      end

      def show?
        (@authorized_roles_for_show & @user_roles).any?
      end

      def index?
        (@authorized_roles_for_index & @user_roles).any?
      end

      def edit?
        (@authorized_roles_for_edit & @user_roles).any?
      end

      def update?
        (@authorized_roles_for_update & @user_roles).any?
      end

      def destroy?
        (@authorized_roles_for_destroy & @user_roles).any?
      end
    end
    TXT

  FileUtils.mkdir_p "lib/#{app_name}/policies" unless File.directory?("lib/#{app_name}/policies")
  unless File.file?("lib/#{app_name}/policies/#{controller}Policy.rb")
    File.open("lib/#{app_name}/policies/#{controller}Policy.rb", 'w') { |file| file.write(policy_txt) }
  end
  puts("Generated policy: lib/#{app_name}/policies/#{controller}Policy.rb") if File.file?("lib/#{app_name}/policies/#{controller}Policy.rb")
end
  end
end
