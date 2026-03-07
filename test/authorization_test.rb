require 'test_helper'
require_relative '../lib/rokku/commands/commands.rb'
require_relative 'testApp/lib/web/policies/TaskPolicy.rb'
require_relative 'testApp/lib/admin/policies/TaskPolicy.rb'
include Commands

describe 'Authorization' do
  before do
    @application_name = 'firstApp'
    @action_web = Web::Controllers::Task::New.new
    @app_name_web = @action_web.controller_name.split("::")[0]
    @controller_name_web = @action_web.controller_name.split("::")[2]
    @action_name_web = @action_web.controller_name.split("::")[3]

    @action_admin = Admin::Controllers::Task::New.new
    @app_name_admin = @action_admin.controller_name.split("::")[0]
    @controller_name_admin = @action_admin.controller_name.split("::")[2]
    @action_name_admin = @action_admin.controller_name.split("::")[3]
  end

  describe 'with authorized user and one role as a string for Web-Task-New' do
    before do
      @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                       roles: 'level_one_user')
      @roles = @user.roles
      end

    after do
      @user = nil
    end

    it 'authorizes the user' do
      assert authorized?(@app_name_web, @controller_name_web, @action_name_web), 'User is authorized'
    end
  end

   describe 'with authorized user and roles as an array of roles for Web-Task-New' do
     before do
       @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                        roles: ['level_one_user', 'level_two_user'])
       @roles = @user.roles
     end

     after do
       @user = nil
     end

     it 'authorizes the user' do
       assert authorized?(@app_name_web, @controller_name_web, @action_name_web), 'User is authorized'
     end
   end

   describe 'with unauthorized user' do
     before do
       @user = User.new(id: 1, name: 'Tester', hashed_pass: '123', roles: 'guest_user')
     end

     after do
       @user = nil
     end

     it 'doesnt authorize the user' do
       refute authorized?(@app_name_web, @controller_name_web, @action_name_web), 'User is not authorized'
     end
   end

   describe 'with authorized user and roles as an array of roles for Admin-Task-New' do
     before do
       @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                        roles: ['level_two_user', 'level_three_user'])
       @roles = @user.roles
     end

     after do
       @user = nil
     end

     it 'authorizes the user' do
       assert authorized?(@app_name_admin, @controller_name_admin, @action_name_admin), 'User is authorized'
     end
   end

   describe 'with unauthorized user' do
     before do
       @user = User.new(id: 1, name: 'Tester', hashed_pass: '123', roles: 'guest_user')
     end

     after do
       @user = nil
     end

     it 'doesnt authorize the user' do
       refute authorized?(@app_name_admin, @controller_name_admin, @action_name_admin), 'User is not authorized'
     end
   end

   describe 'policy file creation' do
     before do
       @new_controller = 'Post'
     end

     after do
       Dir.chdir('test/testApp') do
         file = "lib/#{@application_name.downcase}/policies/#{@new_controller}Policy.rb"
         File.delete if file
       end
     end

     it 'generates policy' do
       Dir.chdir('test/testApp') do
         Commands.generate_policy(@application_name, @new_controller)
         generated_policy_string = "lib/#{@application_name.downcase}/policies/#{@new_controller}Policy.rb"
         assert File.file?("lib/#{@application_name.downcase}/policies/#{@new_controller}Policy.rb"), "The file lib/#{@application_name.downcase}/policies/#{@new_controller}Policy.rb is generated"
         assert File.readlines(generated_policy_string).grep(/authorized_roles_for_new/).size > 0, 'The file has content authorized_roles_for_new.'
         assert File.readlines(generated_policy_string).grep(/#{@application_name.downcase.capitalize}/).size > 0, "The file has content #{@application_name.downcase.capitalize}."
       end
     end
  end
end
