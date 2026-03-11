require 'optparse'
require 'fileutils'

module Commands
  def self.run
    options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "\nHanami 2.x authorization policy generator
    
      Usage:
        rokku -p tasks -a myapp          # Main app: app/policies/tasks_policy.rb
        rokku -p tasks -s admin          # Slice: slices/admin/policies/tasks_policy.rb
      Flags:
      \n"

      opts.on("-p", "--policy POLICY", "Specify a policy name (e.g., tasks, users, posts) - REQUIRED.") do |policy|
          options[:policy] = policy
      end
        
      opts.on("-a", "--app APP", "Specify the main app name (e.g., myapp, mytasks) - used for main app policies.") do |app|
        options[:app] = app
      end
      
      opts.on("-s", "--slice SLICE", "Specify a slice name (e.g., admin, api) - used for slice policies.") do |slice|
        options[:slice] = slice
      end
      
      opts.on("-h", "--help", "Display help.") do
        puts opts
        exit
      end
    end

    begin
      optparse.parse!

      if options.empty?
        puts "Error: no options prodived."
        puts optparse
        exit 1
      end

      unless options[:policy]
        puts "Error: Policy name is required (-p or --policy)."
        puts optparse
        exit 1
      end

      if options[:app] && options[:slice]
        puts "Error: Cannot specify both --app and --slice."
        puts "Use --app for main app policies, --slice for slice policies."
        puts optparse
        exit 1
      end

      unless options[:app] || options[:slice]
        puts "Error: Must specify either --app or --slice."
        puts "Use --app for main app policies, --slice for slice policies."
        puts optparse
        exit 1
      end

    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
      puts "Error: #{e.message}"
      puts optparse
      exit 1
    end

    puts "Generating policy: #{options.inspect}"
    generate_policy(options[:policy], app_name: options[:app], slice_name: options[:slice])
  end

  private
  # The generate_policy method creates the policy file at the main
  # application or slice level for Hanami 2.x applications.
  # By default all actions to check against are commented out.

  # Uncomment the needed actions and define appropriate user roles.

  def self.generate_policy(policy_name, app_name: nil, slice_name: nil)
    if slice_name
      namespace = slice_name.downcase
      policies_dir = "slices/#{namespace}/policies"
    elsif app_name
      namespace = app_name.downcase.capitalize
      policies_dir = "app/policies"
    else
      raise ArgumentError, "Please specify either app_name or slice_name."
    end

    policy_class_name = "#{policy_name.downcase.capitalize}Policy"

    policy_content = <<~RUBY
      # frozen_string_literal: true
      
      module #{namespace.capitalize}
        class #{policy_class_name}
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
      end
    RUBY
    
    FileUtils.mkdir_p(policies_dir) unless File.directory?(policies_dir)
    policy_file = "#{policies_dir}/#{policy_name.downcase}_policy.rb"

    if File.exist?(policy_file)
      puts "Policy already exists: #{policy_file}."
      puts "Skipping generation."
    else
      File.write(policy_file, policy_content)
      puts "✓ Generated policy: #{policy_file}."
      puts "  Namespace: #{namespace.capitalize}::#{policy_class_name}."
    end
  end
end
