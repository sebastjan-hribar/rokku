require 'optparse'
require 'fileutils'

module Commands
  def self.run
    options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "\nHanami authorization policy generator
    Usage: rokku -n myapp -p user
    Flags:
    \n"

      opts.on("-n", "--app_name APP", "Specify the application name for the policy") do |app_name|
        options[:app_name] = app_name
      end

      opts.on("-p", "--policy POLICY", "Specify the policy name") do |policy|
        options[:policy] = policy
      end

      opts.on("-h", "--help", "Displays help") do
        puts opts
        exit
      end
    end

    begin
      optparse.parse!
      puts "Add flag -h or --help to see usage instructions." if options.empty?
      mandatory = [:app_name, :policy]
      missing = mandatory.select{ |arg| options[arg].nil? }
      unless missing.empty?
        raise OptionParser::MissingArgument.new(missing.join(', '))
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts optparse
      exit
    end

    puts "Performing task with options: #{options.inspect}"
    generate_policy("#{options[:app_name]}", "#{options[:policy]}") if options[:policy]
  end

  private
  # The generate_policy method creates the policy file for specified
  # application and controller. By default all actions to check against
  # are commented out.
  # Uncomment the needed actions and define appropriate user roles.

  def self.generate_policy(app_name, controller_name)
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
