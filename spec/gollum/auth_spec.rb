require 'spec_helper'
require 'rack/test'

module Precious
  class FakeApp
    def self.call(env)
      [ 200, { }, [ ] ]
    end
  end
end

describe Gollum::Auth do
  include Rack::Test::Methods

  let(:user_params) do
    FactoryGirl.attributes_for(:user,
                               username: 'admin',
                               email: 'admin@example.com',
                               name: 'Administrator',
                               password: 'password')
  end
  let(:users) do
    [ user_params]
  end
  let(:app) { Gollum::Auth::App.new(Precious::FakeApp, users) }

  it 'has a version number' do
    expect(Gollum::Auth::VERSION).to eq '0.4.0'
  end

  it 'requires authentication on read' do
    get '/Home'
    expect(last_response).to be_unauthorized
    basic_authorize 'admin', 'password'
    get '/Home'
    expect(last_response).to be_ok
  end

  it 'requires authentication on edit' do
    get '/edit/Home'
    expect(last_response).to be_unauthorized
  end

  it 'requires authentication on create' do
    get '/create/Foo'
    expect(last_response).to be_unauthorized
  end

  it 'requires authentication on edits' do
    get '/edit/Home'
    expect(last_response).to be_unauthorized
  end

  it 'denies access with invalid credetials' do
    basic_authorize 'admin', 'wrongpassword'
    get '/edit/Home'
    expect(last_response).to be_unauthorized
  end

  it 'permits access with valid credetials' do
    basic_authorize 'admin', 'password'
    get '/edit/Home'
    expect(last_response).to be_ok
  end

  it 'stores user in session with valid credetials' do
    basic_authorize 'admin', 'password'
    get '/edit/Home'
    session = last_request.env.fetch('rack.session')
    author = session.fetch('gollum.author')
    expect(author[:name]).to eq 'Administrator'
    expect(author[:email]).to eq 'admin@example.com'
  end

  context 'when guests are allowed' do
    let(:options) { { allow_guests: true } }
    let(:app) { Gollum::Auth::App.new(Precious::FakeApp, users, options) }

    it 'does not require authentication on the home page' do
      get '/Home'
      expect(last_response).to be_ok
    end
  end
end
