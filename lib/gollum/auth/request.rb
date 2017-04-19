module Gollum::Auth
  class Request < Rack::Request
    def needs_authentication?(allow_guests)
      !allow_guests || is_change_request?
    end

    def store_author_in_session(user)
      session['gollum.author'] = { name: user.name, email: user.email }
    end

    private

    # Returns true if the request includes a path that would result in a change
    # of the wiki.
    def is_change_request?
      !!(path_info =~ /^\/(create|edit|delete|rename|revert|upload)(\/.*)?$/)
    end
  end
end