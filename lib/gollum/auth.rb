require 'rack'
require 'active_model'
require 'gollum/auth/version'
require 'gollum/auth/request'
require 'gollum/auth/user'

module Gollum
  module Auth
    def self.new(*args)
      App.new(*args)
    end

    class App
      def initialize(app, users, opts = { })
        @app = app
        users.each { |args| User.new(args).save! }
        @opts = { allow_guests: false }.merge(opts)
      end

      def call(env)
        if Request.new(env).needs_authentication?(@opts[:allow_guests])
          auth = Rack::Auth::Basic::Request.new(env)
          unless auth.provided? && auth.basic? && valid?(auth.credentials)
            return [
              401,
              { 'Content-Type' => 'text/plain', 'WWW-Authenticate' => 'Basic realm="Gollum Wiki"' },
              [ 'Not authorized' ]
            ]
          end
        end
        @app.call(env)
      end

      private

      def valid?(credentials)
        username, password = credentials
        current_user = User.find(username)
        current_user && current_user.valid_password?(password)
      end

      def users
        User.all
      end
    end
  end
end
