# Rokku

[![Join the chat at https://gitter.im/sebastjan-hribar/rokku](https://badges.gitter.im/sebastjan-hribar/rokku.svg)](https://gitter.im/sebastjan-hribar/rokku?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Gem Version](https://badge.fury.io/rb/rokku.svg)](https://badge.fury.io/rb/rokku)

Rokku (ロック - lock) offers authorization for [Hanami web applications](http://hanamirb.org/).

Authorization was setup as inspired by [this blog post](http://billpatrianakos.me/blog/2013/10/22/authorize-users-based-on-roles-and-permissions-without-a-gem/). It supports the generation of policy files for each controller where authorized roles are specified for each action.


## Installation

 Add this line to your application's Gemfile:

```ruby
gem 'rokku'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rokku


Rokku is already setup to be included by your Hanami application:

```ruby
::Hanami::Controller.configure do
  prepare do
    include Hanami::Rokku
  end
end
```

## Usage

### Role based authorization

#### Prerequisites
The current user must be stored in the `@user` variable and must have the attribute of `roles`. Rokku supports `roles` both as a type of `Array` and `String`.
For example, the `@user.roles` could either be a simple string like 'admin' or an array of roles like `['level_1', 'level_2', 'level_3']`.

```ruby
rokku -n mightyPoster -p post
```
The above CLI command will generate a policy file for the application mightyPoster (not the project) and the controller post. The file will be generated as `myProject/lib/mightyPoster/policies/PostPolicy.rb`

Each application will have its own `app/policies` folders.

**The command must be run in the project root folder.**

Once the file is generated, the authorized roles variables in the initialize block for required actions need to be uncommented and supplied with specific roles.
For example:

```ruby
# @authorized_roles_for_show = []
# @authorized_roles_for_index = []
# @authorized_roles_for_edit = []
@authorized_roles_for_update = ['admin']
```

Then we can check if a user is authorized for the `mightyPoster` application, `Post` controller and `Update`action.

```ruby
authorized?("mightyposter", "post", "update")
```

A complete example of using Rokku in a Hanami 1.3 applications is available [here](https://sebastjan-hribar.github.io/programming/2022/01/08/rokku-with-hanami.html).


### Changelog

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
