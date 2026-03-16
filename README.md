# Rokku

[![Join the chat at https://gitter.im/sebastjan-hribar/rokku](https://badges.gitter.im/sebastjan-hribar/rokku.svg)](https://gitter.im/sebastjan-hribar/rokku?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Gem Version](https://badge.fury.io/rb/rokku.svg)](https://badge.fury.io/rb/rokku)

Rokku (ロック - lock) offers authorization for [Hanami web applications](http://hanamirb.org/).

Authorization was setup as inspired by [this blog post](http://billpatrianakos.me/blog/2013/10/22/authorize-users-based-on-roles-and-permissions-without-a-gem/). It supports the generation of policy files for each controller where authorized roles are specified for each action.

**Note:** For Hanami 1.3 support, see the [0.7.0 branch](https://github.com/sebastjan-hribar/rokku/tree/0.7.0) or install Rokku 0.7.0.


## 1. Installation

 Add this line to your application's Gemfile:

```ruby
gem 'rokku'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rokku


Rokku 2.0 needs to be included in the action:

```ruby
# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"
require "rokku"

module MyApplication
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Hanami::Rokku

    handle_exception "ROM::TupleCountMismatchError" => :handle_not_found

    private

    def handle_not_found(request, response, exception)
      response.status = 404
      response.format = :html
      response.body = "Not found"
    end
  end
end
```

## 2. Usage

### 2.1 Role based authorization

#### 2.1.1 Prerequisites
Prior to authorizing the user, retrieve the entity from the database and assign it to a variable `user` so it can be passed to the `authorized?` method. Rokku supports `roles` both as a type of `Array` and `String`.
For example, the `user.roles` could either be a simple string like 'admin' or an array of roles like `['level_1', 'level_2', 'level_3']`.

### 2.2 Policy creation
Rokku supports policy creation for either the main application or for a specific slice. Application policies are created in the `app/policies` folder, while the slice policies are created in the `slices/'slice name'/policies`. See the two command examples below.

```ruby
rokku -p tasks -a myapp #=> app/policies/tasks_policy.rb
```

```ruby
rokku -p tasks -s admin #=> app/slices/admin/policies/tasks_policy.rb
```

**The command must be run in the project root folder.**

**Flags:**
* -p, --policy => policy
* -s, --slice => slice
* -a, --app => application


#### 2.2.1 Naming requirements
For multi part names snake case must be used.

```ruby
rokku -p admin_tasks -s admin_tickets #=> app/slices/admin_tickets/policies/admin_tasks_policy.rb
```


### 2.3 Verifying authorization
Once the file is generated, the authorized roles variables in the initialize block for required actions need to be uncommented and supplied with specific roles.

For example:

```ruby
# @authorized_roles_for_show = []
# @authorized_roles_for_index = []
# @authorized_roles_for_edit = []
@authorized_roles_for_update = ['admin']
```

Then we can check if a user is authorized for the `AdminTickets` slice, `AdminTasks` resources and the `Update`action.

```ruby
authorized?(user)
```

The `authorized?` method checks if the specified user has the required role and permission to access the action. It returns true or false and provides the basis for further actions in either case.

Rokku supports 2 modes of arguments specification: automatic and manual.
Automatic fits most cases, since the app or slice name, resource name and action are automatically extracted.

With manual it's possible to do cross-namespace authorization checks and multiple permission checks.

* Automatic

    `authorized?(current_user)`
    
* Manual

    `authorized?(current_user, namespace: "ChessBase", resource: "ChessOpenings", action: "destroy")`
    
The namespace argument can either be the main application name or s slice name.

## 2.4 Authorization verification in a share code module
It is possible to enable session handling in a share code module as provided by Hanami.
To do this, create an authentication module in **app/actions/authentication.rb**.
The example below shows also how to custom values to replace default values in
actions.

```ruby
module ChessBase
  module Actions
    module Authorization
      
      def self.included(action_class)
        action_class.class_eval do
          include Deps["repos.user_repo"]
          before :check_authorization
        end
      end

      private

      def check_authorization(request, response)
        user_id = request.session[:current_user]
        user = user_repo.find_by_id(user_id) if user_id

        if authorized?(user) == false
          response.flash[:failed_notice] = "You tried to visit an URL you are not authorized for."
          response.redirect_to '/'
        end
      end
    end
  end
end
```

We can then simply include the `Authorization` module in actions, where required.

However, if we include this in the base action class, it will be available in all
actions and there is no need for separate includes in actions:

```ruby
#
#
module MyApplication
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Hanami::Rokku
    include Xpresstube::Actions::Authorization

    handle_exception "ROM::TupleCountMismatchError" => :handle_not_found

    private
#
#
```


### Changelog

#### 2.0.0

**Breaking Changes:**
- Supports Hanami ~> 2.0 applications only.
- Application policies are now created in `app/policies`.
- Slice policies are now created in `slices/my_slice/policies`.
- Rokku must be explicitly included in the base action: `include Hanami::Rokku`.
- Rokku 2.0.0 doesn't rely on instance variable like `@user` anymore. Instead, a `user` variable must be passed as an argument to a method.

For Hanami 1.3 support, use Rokku 0.7.0.

#### 0.7.0

* Policies are now scoped under application module so it is possible to have two `Dashboard` policies for two different applications.
* Readme update.

#### 0.6.0

* Change to accept a string or an array as roles.
* Refactored tests.
* Added `commands.rb`to `bin/rokku`.
* Small style changes.

#### 0.5.1

* Readme update
* Refactored tests

#### 0.5.0

* Move from Tachiban


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sebastjan-hribar/rokku. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rokku project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sebastjan-hribar/rokku/blob/master/CODE_OF_CONDUCT.md).
