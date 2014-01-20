require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestLindaClient < MiniTest::Test

  def create_client
    socket = SocketIO::Client::Simple.connect TestServer.url
    Linda::SocketIO::Client.connect socket
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

  def test_write_watch
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now.to_s}

    client.io.on :connect do
      ts = client.tuplespace("test_write_watch")
      ts.watch foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.write a: "b", name: "shokai"
      ts.write write_data
      ts.write foo: "foo", name: "ymrl"
    end
    sleep 0.5
    assert_equal results, [write_data]
  end

  def test_read_before_write
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now.to_s}

    client.io.on :connect do
      ts = client.tuplespace("test_read")
      ts.read foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.read foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.write a: "b", name: "shokai"
      ts.write write_data
      ts.write foo: "foo", name: "ymrl"
    end
    sleep 0.5
    assert_equal results, [write_data, write_data]
  end

  def test_take_before_write
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now.to_s}

    client.io.on :connect do
      ts = client.tuplespace("test_take")
      ts.take foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.take foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.write a: "b", name: "shokai"
      ts.write write_data
      ts.write foo: "foo", name: "ymrl"
    end
    sleep 0.5
    assert_equal results, [write_data]
  end

  def test_watch_cancel
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now}

    client.io.on :connect do
      ts = client.tuplespace("test_watch_cancel")
      id = ts.watch foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.cancel id
      ts.write write_data
    end
    sleep 0.5
    assert_equal results, []
  end

  def test_read_cancel
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now}

    client.io.on :connect do
      ts = client.tuplespace("test_read_cancel")
      cid = ts.read foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.cancel cid
      ts.write write_data
    end
    sleep 0.5
    assert_equal results, []
    assert_equal client.io.__events.select{|e|e[:type].to_s =~ /read/}.size, 0
  end

  def test_take_cancel
    results = []
    client = create_client
    write_data = {"foo" => "bar", "at" => Time.now}

    client.io.on :connect do
      ts = client.tuplespace("test_take_cancel")
      cid = ts.take foo: "bar" do |err, tuple|
        next if err
        results.push tuple["data"]
      end
      ts.cancel cid
      ts.write write_data
    end
    sleep 0.5
    assert_equal results, []
    assert_equal client.io.__events.select{|e|e[:type].to_s =~ /take/}.size, 0
  end

end
