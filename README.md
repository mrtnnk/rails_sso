# SSO client Rails Engine

[![Join the chat at https://gitter.im/monterail/rails_sso](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/monterail/rails_sso?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Circle CI](https://circleci.com/gh/monterail/rails_sso/tree/master.svg?style=shield&circle-token=237c44548fb2c2597bcd0bc7b1dd99c81329e574)](https://circleci.com/gh/monterail/rails_sso/tree/master)
[![Dependency Status](https://gemnasium.com/monterail/rails_sso.svg)](https://gemnasium.com/monterail/rails_sso)
[![Gem Version](https://badge.fury.io/rb/rails_sso.svg)](http://badge.fury.io/rb/rails_sso)
[![Code Climate](https://codeclimate.com/github/monterail/rails_sso/badges/gpa.svg)](https://codeclimate.com/github/monterail/rails_sso)
[![Test Coverage](https://codeclimate.com/github/monterail/rails_sso/badges/coverage.svg)](https://codeclimate.com/github/monterail/rails_sso)

## About

*SOON*

## Installation

Add engine and [omniauth](https://github.com/intridea/omniauth-oauth2) provider gems to your project:

```ruby
# Gemfile

gem 'omniauth-example'
gem 'rails_sso'
```

Install initializer and mount routes:

```bash
bin/rails generate rails_sso
```

Configure initializer:

```ruby
# conifg/initializers/sso.rb

RailsSso.configure do |config|
  # include RailsSso::Helpers to ActionController::Base
  config.magic_enabled = true
  # url of entity provider
  config.provider_url = 'https://example.com'
  # name of oauth2 provider
  config.provider_name = 'example'
  # oauth keys for omniauth-example
  config.provider_key = ENV['PROVIDER_KEY']
  config.provider_secret = ENV['PROVIDER_SECRET']
  # path for fetching user data
  config.provider_profile_path = '/api/v1/profile'
  # set if you support single sign out
  config.provider_sign_out_path = '/api/v1/session'
  # enable cache (will use Rails.cache store)
  config.use_cache = Rails.application.config.action_controller.perform_caching
  # test & development mode
  config.test_mode = ENV['mock_sso']
  config.access_token_mock = ENV['access_token_mock']
  config.profile_mocks = {
    '169783' => {
      user: 'John Blacksmith',
      uid: '169783'
    }
  }
  # custom failure app
  # more: https://github.com/hassox/warden/wiki/Failures
  config.failure_app = MyFailureApp
end
```

And mount it:

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'
end
```

## Usage

Include helpers to your controller if you disabled auto include:

```ruby
class ApplicationController < ActionController::Base
  include RailsSso::Helpers
end
```

Available helpers for controllers and views:

* `current_user_data`
* `user_signed_in?`

Available filters and helpers for controllers:

* `authenticate_user!`
* `sign_in_with_access_token!(access_token)`
* `sign_out!`
* `warden`
* `sso_app`

Available helpers for views:

* `sso.sign_in_path`
* `sso.sign_out_path`

## Testing & Development mode

You can turn on "test mode" by enabling test mode. It will also automatically enable [OmniAuth test mode](https://github.com/intridea/omniauth/wiki/Integration-Testing).

```ruby
RailsSso.configure do
  config.test_mode = true
end
```

Mock data should be passed to `profile_mocks` configuration with dummy access token as a key.

```ruby
RailsSso.configure do |config|
  config.profile_mocks = {
    "kowalski_uid" => {
      "name" => "John Kowalski",
      "uid" => "42"
    },
    "nowak_uid" => {
      "name" => "Pawel Nowak",
      "uid" => "23"
    }
  }
end
```

Finally you have to select which token to use.

```ruby
RailsSso.configure do |config|
  config.access_token_mock = "kowalski_uid"
end
```

To mock signed out state set `nil` to access token value.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
