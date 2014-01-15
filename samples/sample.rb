$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'linda-socket.io-client'

linda = Linda::SocketIO::Client.connect 'http://localhost:3000'
ts = linda.tuplespace('test')

linda.io.on :connect do
  puts "connect!! #{linda.url}"

  loop do
    puts "writing"
    ts.write :msg => "hello hello", :at => Time.now
    sleep 1
  end
end

loop do
end
