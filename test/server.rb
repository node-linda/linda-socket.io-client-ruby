class TestServer

  def self.port
    (ENV['PORT'] || 13000).to_i
  end

  def self.start(exit_at=5000)
    system "PORT=#{port} EXIT_AT=#{exit_at} npm start > /dev/null &"
    sleep 1
  end

  def self.url
    "http://localhost:#{port}"
  end

end

TestServer.start
