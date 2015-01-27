require 'minitest'
require 'minitest/autorun'

require 'tiny_rack_flash'
require 'rack'
require 'rack/test'

require 'sinatra/base'
require "cuba"

class SinatraApp < Sinatra::Base
  
  use TinyRackFlash do |mixins|
    include mixins
  end

  set :sessions, true

  get '/' do
    flash[:success] = 'success'
    redirect '/redirect'
  end

  get '/redirect' do
    flash[:success]
  end

  get '/show_now' do
    flash.now[:success] = 'ready'
    flash[:success]
  end
end

class CubaApp < Cuba

  use Rack::Session::Cookie, secret: "__a_very_long_string__"
  use TinyRackFlash do |mixins|
    include mixins
  end

  define do
    on root do
      flash[:success] = 'success'
      res.redirect '/redirect'
    end

    on 'redirect' do
      res.write flash[:success]
    end

    on 'show_now' do
      flash.now[:success] = 'ready'
      res.write flash[:success]
    end
  end

end

class TinyRackFlashTest < Minitest::Test
  
  include Rack::Test::Methods

  module Common
    def test_shows_flash_when_appropriate
      get '/'
      follow_redirect!
      assert_equal('success', last_response.body)
    end

    def test_not_shows_flash_when_appropriate
      get '/redirect'
      assert_equal('', last_response.body)
    end

    def test_shows_flash_now_when_appropriate
      get '/show_now'
      assert_equal('ready', last_response.body)
    end
  end

  class SinatraAppTest < self
    def app; SinatraApp; end
    include Common
  end

  class CubaAppTest < self
    def app; CubaApp; end
    include Common
  end

end