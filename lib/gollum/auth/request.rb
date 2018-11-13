module Gollum::Auth
  class Request < Rack::Request
    def requires_authentication?(allow_guests)
      !allow_guests || is_write_path?
    end

    def store_author_in_session(user)
      session['gollum.author'] = { name: user.name, email: user.email }
    end

    private

    # Returns true if path is a write path that would change the wiki.
    def is_write_path?
      !!(path_info =~ /^\/(create|edit|delete|rename|revert|uploadFile)(\/.*)?$/)
    end
  end
end
