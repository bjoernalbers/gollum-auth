require 'spec_helper'

module Gollum::Auth
  describe Request do
    def build_request(path = '/')
      env = Rack::MockRequest.env_for("http://example.com#{path}")
      Request.new(env)
    end

    describe '#needs_authentication?' do
      shared_examples 'write paths need authentication' do
        it 'is true for write paths' do
          %w(create edit delete rename revert upload).each do |path|
            subject = build_request "/#{path}"
            expect(subject.needs_authentication?(allow_guests)).to eq(true),
              "expect path /#{path} to need authentication"
          end
        end
      end

      context 'when guests are not allowed' do
        let(:allow_guests) { false }

        it 'is true for read paths' do
          subject = build_request '/Home'
          expect(subject.needs_authentication?(allow_guests)).to eq true
        end

        include_examples 'write paths need authentication'
      end

      context 'when guests are allowed' do
        let(:allow_guests) { true }

        it 'is false for read paths' do
          subject = build_request '/Home'
          expect(subject.needs_authentication?(allow_guests)).to eq false
        end

        include_examples 'write paths need authentication'
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
