require 'spec_helper'

module Gollum::Auth
  describe Request do
    def build_request(path = '/')
      env = Rack::MockRequest.env_for("http://example.com#{path}")
      Request.new(env)
    end

    describe '#needs_authentication?' do
      let(:allow_guests) { false }

      it 'is true for read requests' do
        subject = build_request '/Home'
        expect(subject.needs_authentication?(allow_guests)).to eq true
      end

      %w(create edit delete rename revert upload).each do |path|
        it "is true on #{path}" do
          subject = build_request "/#{path}"
          expect(subject.needs_authentication?(allow_guests)).to eq true
        end
      end

      context 'when guests are allowed' do
        let(:allow_guests) { true }

        it 'is false for read requests' do
          subject = build_request '/Home'
          expect(subject.needs_authentication?(allow_guests)).to eq false
        end

        %w(create edit delete rename revert upload).each do |path|
          it "is true on #{path}" do
            subject = build_request "/#{path}"
            expect(subject.needs_authentication?(allow_guests)).to eq true
          end
        end
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
