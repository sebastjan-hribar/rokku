require 'test_helper'
require_relative '../lib/rokku/commands/commands.rb'
require_relative 'Testapp/app/policies/tasks_policy.rb'
require_relative 'Testapp/slices/admin/policies/tasks_policy.rb'

describe 'Authorization' do
  before do
    @application_name = 'Testapp'
    
    @action_app = Testapp::Actions::Tasks::New.new
    @app_name = @action_app.action_name.split("::")[0] # => "Testapp"
    @resource_name_app = @action_app.action_name.split("::")[2] # => "Tasks"
    @action_name_app = @action_app.action_name.split("::")[3] # => "New"

    @action_admin = Admin::Actions::Tasks::New.new
    @app_name_admin = @action_admin.action_name.split("::")[0] # => "Admin"
    @resource_name_admin = @action_admin.action_name.split("::")[2] # => "Tasks"
    @action_name_admin = @action_admin.action_name.split("::")[3] # => "New"
  end

  describe 'with authorized user and one role as a string for Testapp-Task-New' do
    before do
      @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                       roles: 'level_one_user')
    end

    after do
      @user = nil
    end

    it 'authorizes the user' do
      assert authorized?(@user, namespace: @app_name, resource: @resource_name_app, action: @action_name_app), 'User is authorized'
    end
  end

  describe 'with authorized user and roles as an array of roles for Web-Task-New' do
    before do
      @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                      roles: ['level_one_user', 'level_two_user'])
    end

    after do
      @user = nil
    end

    it 'authorizes the user' do
      assert authorized?(@user, namespace: @app_name, resource: @resource_name_app, action: @action_name_app), 'User is authorized'
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
      refute authorized?(@user, namespace: @app_name, resource: @resource_name_app, action: @action_name_app), 'User is not authorized'
    end
  end

  describe 'with authorized user and roles as an array of roles for Admin-Task-New' do
    before do
      @user = User.new(id: 1, name: 'Tester', hashed_pass: '123',
                      roles: ['level_two_user', 'level_three_user'])
    end

    after do
      @user = nil
    end

    it 'authorizes the user' do
      assert authorized?(@user, namespace: @app_name_admin, resource: @resource_name_admin, action: @action_name_admin), 'User is authorized'
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
      refute authorized?(@user, namespace: @app_name_admin, resource: @resource_name_admin, action: @action_name_admin), 'User is not authorized'
    end
  end

  describe 'policy file creation: one part namespace' do
    before do
      @app_name = 'Testapp'
      @app_resource_name = 'Openings'
      
      @slice_name = 'Admin'
      @slice_resource_name = 'Tickets'
    end

    after do
      Dir.chdir('test/Testapp') do
        file = "app/policies/#{@app_resource_name.downcase}_policy.rb"
        File.delete(file) if File.exist?(file) 
      end

      Dir.chdir('test/Testapp') do
        file = "slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"
        File.delete(file) if File.exist?(file) 
      end
    end

    it 'generates main app policy' do
      Dir.chdir('test/Testapp') do
        Commands.generate_policy(@app_resource_name, app_name: @app_name)
        generated_policy_string = "app/policies/#{@app_resource_name.downcase}_policy.rb"
        assert File.file?("app/policies/#{@app_resource_name.downcase}_policy.rb"), "The file app/policies/posts_policy.rb is generated."
        assert File.readlines(generated_policy_string).grep(/authorized_roles_for_new/).size > 0, 'The file has content authorized_roles_for_new.'
        assert File.readlines(generated_policy_string).grep(/#{@app_name}/).size > 0, "The file has content 'Testapp'."
      end
    end

    it 'generates slice policy' do
      Dir.chdir('test/Testapp') do
        Commands.generate_policy(@slice_resource_name, slice_name: @slice_name)
        generated_policy_string = "slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"
        assert File.file?("slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"), "The file 'slices/admin/policies/books_policy.rb' is generated."
        assert File.readlines(generated_policy_string).grep(/authorized_roles_for_new/).size > 0, 'The file has content authorized_roles_for_new.'
        assert File.readlines(generated_policy_string).grep(/#{@slice_name.downcase.capitalize}/).size > 0, "The file has content 'Admin'."
      end
    end
  end

  describe 'policy file creation: multi part namespace' do
    before do
      @app_name = 'chess_base'
      @app_resource_name = 'chess_openings'
      
      @slice_name = 'Chess_admin'
      @slice_resource_name = 'user_tickets'
    end

    after do
      Dir.chdir('test/Testapp') do
        file = "app/policies/#{@app_resource_name.downcase}_policy.rb"
        File.delete(file) if File.exist?(file) 
      end

      Dir.chdir('test/Testapp') do
        file = "slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"
        File.delete(file) if File.exist?(file) 
      end
    end

    it 'generates main app policy' do
      Dir.chdir('test/Testapp') do
        Commands.generate_policy(@app_resource_name, app_name: @app_name)
        generated_policy_string = "app/policies/#{@app_resource_name.downcase}_policy.rb"
        
        assert File.file?("app/policies/#{@app_resource_name.downcase}_policy.rb"), "The file app/policies/posts_policy.rb is generated."
        assert File.readlines(generated_policy_string).grep(/authorized_roles_for_new/).size > 0, 'The file has content authorized_roles_for_new.'
        assert File.readlines(generated_policy_string).grep(/ChessBase/).size > 0, "The file has content 'ChessBase'."
      end
    end

    it 'generates slice policy' do
      Dir.chdir('test/Testapp') do
        Commands.generate_policy(@slice_resource_name, slice_name: @slice_name)
        generated_policy_string = "slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"
        
        assert File.file?("slices/#{@slice_name.downcase}/policies/#{@slice_resource_name.downcase}_policy.rb"), "The file 'slices/admin/policies/books_policy.rb' is generated."
        assert File.readlines(generated_policy_string).grep(/authorized_roles_for_new/).size > 0, 'The file has content authorized_roles_for_new.'
        assert File.readlines(generated_policy_string).grep(/ChessAdmin/).size > 0, "The file has content 'ChessAdmin'."
      end
    end
  end
end
