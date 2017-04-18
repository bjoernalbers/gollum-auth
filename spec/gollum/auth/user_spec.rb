require 'spec_helper'
require 'rack/test'

module Gollum::Auth
  describe User do
    let(:params)  { { user: 'Homer', password: 'Marge' } }
    let(:subject) { User.new(params) }

    describe '#user' do
      it 'can be set' do
        expect(subject.user).to eq 'Homer'
      end
    end

    describe '#password' do
      it 'can be set' do
        expect(subject.password).to eq 'Marge'
      end
    end
  end
end
