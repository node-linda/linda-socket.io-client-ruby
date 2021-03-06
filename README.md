# Linda::SocketIO::Client

- Ruby client for [node-linda](https://github.com/node-linda/linda)
- https://github.com/node-linda/linda-socket.io-client-ruby
- http://rubygems.org/gems/linda-socket.io-client

[![Travis-CI build status](https://travis-ci.org/node-linda/linda-socket.io-client-ruby.png?branch=master)](https://travis-ci.org/node-linda/linda-socket.io-client-ruby)


## Installation

    % gem install linda-socket.io-client


## Usage

[samples/sample.rb](https://github.com/node-linda/linda-socket.io-client-ruby/blob/master/samples/sample.rb)
```ruby
require 'rubygems'
require 'linda-socket.io-client'

linda = Linda::SocketIO::Client.connect 'http://node-linda-base.herokuapp.com'
ts = linda.tuplespace('test')

linda.io.on :connect do
  puts "connect!! #{linda.url}"

  ts.watch type: "chat" do |err, tuple|
    next if err
    puts "> #{tuple.data.msg} (from:#{tuple.from})"
  end
end

linda.io.on :disconnect do
  puts "disconnect"
end

linda.io.on :error do |err|
  p err
end

while line = STDIN.gets
  line.strip!
  next if line.empty?
  ts.write(type: "chat", msg: line, at: Time.now)
end
```


## Test

    % gem install bundler
    % bundle install
    % npm install
    % bundle exec rake test


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
