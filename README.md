# Rokku

[![Join the chat at https://gitter.im/sebastjan-hribar/rokku](https://badges.gitter.im/sebastjan-hribar/rokku.svg)](https://gitter.im/sebastjan-hribar/rokku?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Gem Version](https://badge.fury.io/rb/rokku.svg)](https://badge.fury.io/rb/rokku) [![Build Status](https://travis-ci.org/sebastjan-hribar/rokku.svg?branch=master)](https://travis-ci.org/sebastjan-hribar/rokku)

Rokku (ロック - lock) offers authorization for [Hanami web applications](http://hanamirb.org/).

Authorization was setup as inspired by [this blog post](http://billpatrianakos.me/blog/2013/10/22/authorize-users-based-on-roles-and-permissions-without-a-gem/). It support the generation of policy files for each controller where authorized roles are specified for each action.


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

```ruby
rokku -n mightyPoster -p post
```
The above CLI command will generate a policy file for the application mightyPoster (not the project) and the controller post. The file will be generated as `myProject/lib/mightyPoster/policies/PostPolicy.rb`

Each application would have its own `app/policies` folders.

**The command must be run in the project root folder.**

Once the file is generated the authorized roles variables in the initialize block for required actions need to be uncommneted and supplied with specific roles.

Then we can check if a user is authorized:

```ruby
authorized?(controller, role, action)
```


### ToDo

- Add support for author/owner authorizations.
- Add generators for adding authorization rules to existing policies.


### Changelog

#### 0.5.0

Move from Tachiban`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sebastjan-hribar/rokku. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rokku project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sebastjan-hribar/rokku/blob/master/CODE_OF_CONDUCT.md).
