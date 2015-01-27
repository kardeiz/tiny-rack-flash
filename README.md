# TinyRackFlash

A very small flash implementation for Rack apps

Works well with Cuba, Sinatra, and others--

## Installation

Add this line to your application's Gemfile:

    gem 'tiny-rack-flash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiny-rack-flash

## Usage

Inside your main Rack class (e.g., `Sinatra::Base` or `Cuba`), simply add a

    require 'tiny_rack_flash'
    include TinyRackFlash

The `include` will hook up some Rack middleware for rotating the flash and provide a `flash` method for use in your route handlers.

See `tests.rb` for examples.

## Notes

This gem's `FlashHash` implementation is taken from Stephen Eley's `FlashHash` implementation at https://github.com/SFEley/sinatra-flash.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
