$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'linda-socket.io-client'

linda = Linda::SocketIO::Client.connect 'http://localhost:3000'
ts = linda.tuplespace('test')

linda.io.on :connect do
  puts "connect!! #{linda.url}"

  ts.watch :type => "chat" do |err, tuple|
    p tuple["data"]
  end

end

linda.io.on :disconnect do
  puts "disconnect"
end

loop do
  ts.write :type => "chat", :msg => "hello hello", :at => Time.now
  sleep 1
end
