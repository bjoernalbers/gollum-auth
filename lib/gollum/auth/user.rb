module Gollum::Auth
  class InvalidUserError < StandardError
  end

  class User
    include ActiveModel::Model

    attr_accessor :user, :password

    validates_presence_of :user, :password

    class << self
      def find(user)
        all.select { |u| u.user == user }.first
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
