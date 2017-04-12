require "spec_helper"
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

  let(:users) do
    [ { 'user' => 'admin', 'password' => 'password' } ]
  end
  let(:app) { Gollum::Auth::App.new(Precious::FakeApp, users: users) }

  it 'has a version number' do
    expect(Gollum::Auth::VERSION).to eq '0.0.1'
  end

  it 'does not require authentication on the home page' do
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
end
