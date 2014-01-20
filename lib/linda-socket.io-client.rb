require "linda-socket.io-client/version"
require "linda-socket.io-client/error"
require "linda-socket.io-client/client"

require 'json'
require 'event_emitter'
require 'socket.io-client-simple'

module Linda
 module SocketIO
    module Client

      def self.connect(url_or_io)
        Linda::SocketIO::Client::Client.new(url_or_io)
      end

    end
  end
end
