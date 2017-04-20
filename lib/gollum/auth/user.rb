module Gollum::Auth
  class InvalidUserError < StandardError
  end

  class User
    include ActiveModel::Model

    attr_accessor :username, :password_digest, :name, :email

    validates_presence_of :username, :password_digest, :name, :email
    validates_format_of :username, with: /\A[\w\.-]+\Z/
    validates_format_of :password_digest, with: /\A[0-9a-f]{64}\Z/

    class << self
      def find_by_credentials(credentials)
        username, password = credentials
        user = find(username)
        user if user && user.valid_password?(password)
      end

      def find(username)
        all.select { |u| u.username == username }.first
      end

      def all
        @all ||= []
      end

      def delete_all
        @all = []
      end
    end

    def save!
      save ? self : raise(InvalidUserError, error_message)
    end

    def save
      valid? ? (self.class.all << self; true) : false
    end

    def valid_password?(password)
      password_digest == build_digest(password)
    end

    def password=(password)
      self.password_digest = build_digest(password.to_s) if password
    end

    private

    def build_digest(password)
      Digest::SHA256.hexdigest(password)
    end

    def error_message
      errors.full_messages.join(', ')
    end
  end
end
