require 'delegate'

class TinyRackFlash
  
  FlashKey   = 'tiny.rack.flash'.freeze
  SessionKey = 'rack.session'.freeze
  
  # This FlashHash implmentation is taken from Stephen Eley's work
  # at https://github.com/SFEley/sinatra-flash/blob/master/lib/sinatra/flash/hash.rb
  # which in turn is heavily inspired by ActionDispatch::Flash::FlashHash
  # at https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/flash.rb

  class FlashHash < DelegateClass(Hash)
    attr_reader :now, :next
    def initialize(session)
      @now = session || Hash.new
      @next = Hash.new
      super(@now)
    end

    def []=(key, value)
      self.next[key] = value
    end

    def sweep
      @now.replace(@next)
      @next = Hash.new
      @now
    end

    def keep(key=nil)
      if key
        @next[key] = @now[key]
      else
        @next.merge!(@now)
      end
    end
    
    def discard(key=nil)
      if key
        @next.delete(key)
      else
        @next = Hash.new
      end
    end
  end

  module Helpers
    def flash
      env[FlashKey] ||= begin
        session = env[SessionKey]
        FlashHash.new((session ? session[FlashKey] : {}))
      end
    end
  end
  
  def initialize(app, opts={})
    @app, @opts = app, opts
    yield Helpers if block_given?
  end
  
  def call(env)
    res = @app.call(env)
    env[SessionKey][FlashKey] = env[FlashKey].next if env[FlashKey]
    res
  end

end