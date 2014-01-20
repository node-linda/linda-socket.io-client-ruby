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
        end

        def tuplespace(name)
          TupleSpace.new(self, name.to_s)
        end

      end

      class TupleSpace

        attr_reader :name

        def initialize(linda, name)
          @name = name
          @linda = linda
          @watch_callback_ids = {}
          @io_callbacks = []
        end

        def write(tuple, opts={})
          data = {:tuplespace => @name, :tuple => tuple, :options => opts}
          @linda.io.emit '__linda_write', data
        end

        def take(tupoe, &block)
          return unless block_given?
        end

        def watch(tuple, &block)
          return unless block_given?
          id = create_watch_callback_id tuple
          name  = "__linda_watch_#{id}"
          io_cid = @linda.io.on name, &block
          @io_callbacks.push :name => name, :callback_id => io_cid
          @linda.io.emit '__linda_watch', {:tuplespace => @name, :tuple => tuple, :id => id}
          return id
        end

        private
        def create_callback_id
          "#{Time.now.to_i}_#{rand 10000}"
        end

        def create_watch_callback_id(tuple)
          key = tuple.to_json
          return @watch_callback_ids[key] ||= create_callback_id
        end

      end

    end
  end
end
