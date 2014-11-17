# Appbin::Upload

Upload application binary.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'appbin-upload'
```

And then execute:

    $ bundle

## Usage

```ruby
require 'appbin/upload'

response = Appbin::Upload::Post.new({
  :endpoint => 'http://yourhost.com'
}).upload(apk_path)
```

## Contributing

1. Fork it ( https://github.com/sumipan/appbin-upload.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
