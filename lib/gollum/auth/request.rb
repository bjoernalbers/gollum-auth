module Gollum::Auth
  class Request < Rack::Request
    WRITE_PATH_RE = %r{
      ^/
      (gollum/)? # This path prefix was introduced in Gollum 5
      (create/|edit/|delete/|rename/|revert/|uploadFile$|upload_file$)
    }x

    def requires_authentication?(allow_unauthenticated_readonly)
      !allow_unauthenticated_readonly || is_write_path?
    end

    def store_author_in_session(user)
      session['gollum.author'] = { name: user.name, email: user.email }
    end

    private

    # Returns true if path is a write path that would change the wiki.
    def is_write_path?
      !!(path_info =~ WRITE_PATH_RE)
    end
  end
end
