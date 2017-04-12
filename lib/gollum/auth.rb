require "gollum/auth/version"

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
        puts "Authenticating..."
        @app.call(env)
      end
    end
  end
end
