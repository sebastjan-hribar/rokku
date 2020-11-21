require 'fileutils'

require 'hanami/controller'
require 'hanami/action/session'

module Hanami
  module Rokku

    private
# The generate_policy method creates the policy file for specified
# application and controller. By default all actions to check against
# are commented out.
# Uncomment the needed actions and define appropriate user role.

def generate_policy(app_name, controller_name)
  app_name = app_name
  controller = controller_name.downcase.capitalize
  policy_txt = <<-TXT
    class #{controller}Policy
      def initialize(role)
        @user_role = role
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
        @authorized_roles_for_new.include? @user_role
      end
      def create?
        @authorized_roles_for_create.include? @user_role
      end
      def show?
        @authorized_roles_for_show.include? @user_role
      end
      def index?
        @authorized_roles_for_index.include? @user_role
      end
      def edit?
        @authorized_roles_for_edit.include? @user_role
      end
      def update?
        @authorized_roles_for_update.include? @user_role
      end
      def destroy?
        @authorized_roles_for_destroy.include? @user_role
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
