require 'rack'
require 'gollum/auth/version'

module Gollum
  module Auth
    def self.new(*args)
      App.new(*args)
    end

    class App
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        if request.path_info =~ /^\/(create|edit|delete|rename|revert|upload)(\/.*)?$/
          auth = Rack::Auth::Basic::Request.new(env)
          unless auth.provided? && auth.basic? && auth.credentials == ['admin', 'password']
            return [
              401,
              { 'Content-Type' => 'text/plain', 'WWW-Authenticate' => 'Basic realm="Gollum Wiki"' },
              [ 'Not authorized' ]
            ]
          end
        end
        @app.call(env)
      end
    end
  end
end
