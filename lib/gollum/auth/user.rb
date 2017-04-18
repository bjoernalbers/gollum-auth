module Gollum::Auth
  class User
    include ActiveModel::Model

    attr_accessor :user, :password
  end
end
