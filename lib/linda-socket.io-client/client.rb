module Linda
  module SocketIO
    module Client

      def self.connect(url_or_io)
        ::Linda::SocketIO::Client::Client.new(url_or_io)
      end

      class Tuple < ::Hashie::Mash
      end

      class Client

        attr_reader :io

        def initialize(url_or_io)
          if url_or_io.kind_of? String
            @io = ::SocketIO::Client::Simple.connect url_or_io
          elsif url_or_io.kind_of? ::SocketIO::Client::Simple::Client
            @io = url_or_io
          end
        end

        def tuplespace(name)
          TupleSpace.new(self, name.to_s)
        end

        def url
          @io.url
        end

      end

      class TupleSpace

        attr_reader :name

        def initialize(linda, name)
          @name = name
          @linda = linda
          @watch_callback_ids = {}
          @io_callback_ids = []
          this = self
          @linda.io.on 'disconnect' do
            this.remove_io_callbacks
          end
        end

        def create_callback_id
          "#{Time.now.to_i}_#{rand 10000}"
        end

        def create_watch_callback_id(tuple)
          key = tuple.to_json
          return @watch_callback_ids[key] ||= create_callback_id
        end

        def remove_io_callbacks
          @io_callback_ids.each do |id|
            @linda.io.remove_listener id
          end
          @io_callback_ids = []
        end

        def write(tuple, opts={})
          data = {:tuplespace => @name, :tuple => tuple, :options => opts}
          @linda.io.emit '__linda_write', data
        end

        def take(tuple, &block)
          return unless block_given?
          id = create_callback_id
          name = "__linda_take_#{id}"
          io_cid = @linda.io.once name do |err, tuple|
            block.call err, Tuple.new(tuple)
          end
          @io_callback_ids.push io_cid
          @linda.io.emit '__linda_take', {:tuplespace => @name, :tuple => tuple, :id => id}
          return id
        end

        def read(tuple, &block)
          return unless block_given?
          id = create_callback_id
          name = "__linda_read_#{id}"
          io_cid = @linda.io.once name do |err, tuple|
            block.call err, Tuple.new(tuple)
          end
          @io_callback_ids.push io_cid
          @linda.io.emit '__linda_read', {:tuplespace => @name, :tuple => tuple, :id => id}
          return id
        end

        def watch(tuple, &block)
          return unless block_given?
          id = create_watch_callback_id tuple
          name  = "__linda_watch_#{id}"
          io_cid = @linda.io.on name do |err, tuple|
            block.call err, Tuple.new(tuple)
          end
          @io_callback_ids.push io_cid
          @linda.io.emit '__linda_watch', {:tuplespace => @name, :tuple => tuple, :id => id}
          return id
        end

        def cancel(id)
          @linda.io.emit '__linda_cancel', {:tuplespace => @name, :id => id}
        end

      end

    end
  end
end
