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
        request = Request.new(env)
        if request.needs_authentication?(@opts[:allow_guests])
          auth = Rack::Auth::Basic::Request.new(env)
          if auth.provided? && auth.basic? && user = User.find_by_credentials(auth.credentials)
            request.store_author_in_session(user)
          else
            return not_authorized
          end
        end
        @app.call(env)
      end

      private

      def not_authorized
        [
          401,
          {
            'Content-Type'     => 'text/plain',
            'WWW-Authenticate' => 'Basic realm="Gollum Wiki"'
          },
          [ 'Not authorized' ]
        ]
      end
    end
  end
end
