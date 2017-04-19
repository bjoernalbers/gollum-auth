# Gollum::Auth - Authentication Middleware for Gollum Wiki

[![Gem Version](https://badge.fury.io/rb/gollum-auth.svg)](https://badge.fury.io/rb/gollum-auth)
[![Build Status](https://travis-ci.org/bjoernalbers/gollum-auth.svg?branch=master)](https://travis-ci.org/bjoernalbers/gollum-auth)

`Gollum::Auth` is a Rack-Middleware to add
[HTTP Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
to
[gollum](https://github.com/gollum/gollum).
This requires users to authenticate in order to change the wiki (create /
edit / delete / rename / revert pages).
Read-only access is permitted by default.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gollum-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gollum-auth


## Usage

You have to run
[Gollum via Rack](https://github.com/gollum/gollum/wiki/Gollum-via-Rack)
and use this middleware *before* gollum.
Here is a sample `config.ru`:

```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'gollum/auth' # Don't forget to load the gem!
require 'gollum/app'

# Define list of authorized users where each must have a "name", "password"
and "email":
users = YAML.load %q{
---
- name: Rick Sanchez
  password: asdf754&1129-@lUZw
  email: rick@example.com
- name: Morty Smith
  password: 12345
  email: morty@example.com
}

# Allow only authenticated users to access and change the wiki.
# (NOTE: This must be loaded *before* Precious::App!)
use Gollum::Auth, users

# That's it. The rest is for gollum only.
gollum_path = File.expand_path(File.dirname(__FILE__)) # CHANGE THIS TO POINT TO YOUR OWN WIKI REPO
wiki_options = {:universal_toc => false}
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:wiki_options, wiki_options)
run Precious::App
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on the official
[GitHub Repository](https://github.com/bjoernalbers/gollum-auth).
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](LICENSE.txt).
