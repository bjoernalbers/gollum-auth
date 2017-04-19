module Gollum::Auth
  class InvalidUserError < StandardError
  end

  class User
    include ActiveModel::Model

    attr_accessor :username, :password, :name, :email

    validates_presence_of :username, :password, :name, :email
    validates_format_of :username, with: /\A[-a-zA-Z\d\._]+\Z/

    class << self
      def find(username)
        all.select { |u| u.username == username }.first
      end

      def all
        @all ||= []
      end
    end

    def save!
      save ? self : raise(InvalidUserError, error_message)
    end

    def save
      (self.class.all << self; self) if valid?
    end

    def valid_password?(other)
      password == other
    end

    private

    def error_message
      errors.full_messages.join(', ')
    end
  end
end
