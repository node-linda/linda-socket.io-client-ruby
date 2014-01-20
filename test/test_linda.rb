require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestLindaClient < MiniTest::Test

  def setup
    TestServer.start
  end

  def test_connect
    linda = Linda::SocketIO::Client.connect TestServer.url
    result = false
    linda.io.on :connect do
      result = true
    end
    sleep 0.5
    assert result
  end

  def test_socketio_client_wrap
    socket = SocketIO::Client::Simple.connect TestServer.url
    linda = Linda::SocketIO::Client.connect socket
    result = false
    linda.io.on :connect do
      result = true
    end
    sleep 0.5
    assert result
  end

end
