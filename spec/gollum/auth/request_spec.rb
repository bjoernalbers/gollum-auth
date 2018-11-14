require 'spec_helper'

module Gollum::Auth
  describe Request do
    def build_request(path = '/')
      env = Rack::MockRequest.env_for("http://example.com#{path}")
      Request.new(env)
    end

    describe '#requires_authentication?' do
      shared_examples 'write paths require authentication' do
        it 'is true for write paths (Gollum 4)' do
          %w(
            /create/foo.md
            /edit/foo.md
            /delete/foo.md
            /rename/foo.md
            /revert/Home/07552da/a5e4711
            /uploadFile
          ).each do |path|
            subject = build_request path
            expect(subject.requires_authentication?(allow_unauthenticated_readonly)).to eq(true),
              "expect path #{path} to require authentication"
          end
        end

        it 'is true for write paths (Gollum 5)' do
          %w(
            /gollum/create/foo.md
            /gollum/edit/foo.md
            /gollum/delete/foo.md
            /gollum/rename/foo.md
            /gollum/revert/Home/07552da/a5e4711
            /gollum/upload_file
          ).each do |path|
            subject = build_request path
            expect(subject.requires_authentication?(allow_unauthenticated_readonly)).to eq(true),
              "expect path #{path} to require authentication"
          end
        end
      end

      context 'when unauthenticated readonly is forbidden' do
        let(:allow_unauthenticated_readonly) { false }

        it 'is true for read paths' do
          subject = build_request '/Home'
          expect(subject.requires_authentication?(allow_unauthenticated_readonly)).to eq true
        end

        include_examples 'write paths require authentication'
      end

      context 'when unauthenticated readonly is allowed' do
        let(:allow_unauthenticated_readonly) { true }

        it 'is false for read paths' do
          subject = build_request '/Home'
          expect(subject.requires_authentication?(allow_unauthenticated_readonly)).to eq false
        end

        include_examples 'write paths require authentication'
      end
    end

    describe '#store_author_in_session' do
      let(:user) { build(:user) }

      it 'updates the session' do
        subject = build_request
        subject.store_author_in_session(user)
        author = subject.session.fetch('gollum.author')
        expect(author[:name]).to eq user.name
        expect(author[:email]).to eq user.email
      end
    end
  end
end
