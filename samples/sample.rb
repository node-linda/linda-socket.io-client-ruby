$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'linda-socket.io-client'

linda = Linda::SocketIO::Client.connect 'http://localhost:3000'
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

while line = STDIN.gets
  line.strip!
  next if line.empty?
  ts.write(type: "chat", msg: line, at: Time.now)
end
