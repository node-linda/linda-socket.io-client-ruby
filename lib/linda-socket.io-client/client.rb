module Linda
  module SocketIO
    module Client

      class Client

        attr_reader :io, :url

        def initialize(url_or_io)
          if url_or_io.kind_of? String
            @url = url_or_io
          elsif url_or_io.kind_of? ::SocketIO::Client::Simple::Client
            @io = url_or_io
            @url = @io.url
          end

          @io = ::SocketIO::Client::Simple.connect @url
          @@tuplespaces = {}
        end

        def tuplespace(name)
          @@tuplespaces[name.to_s] ||= TupleSpace.new(name.to_s, self)
        end

      end

      class TupleSpace

        attr_reader :name

        def initialize(name, client)
          @name = name
          @client = client
        end

        def write(tuple, opts={})
          data = {:tuplespace => @name, :tuple => tuple, :options => opts}
          @client.io.emit '__linda_write', data
        end
        
      end

    end
  end
end
