module Gollum::Auth
  class InvalidUserError < StandardError
  end

  class User
    include ActiveModel::Model

    attr_accessor :user, :password

    validates_presence_of :user, :password

    def self.all
      @all ||= []
    end

    def save!
      save ? self : raise(InvalidUserError, error_message)
    end

    def save
      (self.class.all << self; self) if valid?
    end

    private

    def error_message
      errors.full_messages.join(', ')
    end
  end
end
