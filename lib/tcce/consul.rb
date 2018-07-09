require 'diplomat'
require 'stringio'
require 'zlib'

module TCCE
  class Consul
    attr_accessor :kv_path

    # @param [String] url consul api url
    # @param [String] acl_token consul acl token
    # @param [String] kv_path consul path to object
    # @param [String] ca_file Path to ca file
    def initialize(url, acl_token, kv_path, ca_file = nil)
      self.kv_path = kv_path

      Diplomat.configure do |config|
        # Set up a custom Consul URL
        config.url = url

        # Connect into consul with custom access token (ACL)
        config.acl_token = acl_token

        # Set extra Faraday configuration options
        config.options = { ssl: {
          version: :TLSv1_2,
          ca_file: ca_file
        } }
      end
    end

    # Query the +kv_path+ from consul
    # @return [String] object
    def get(inflate = true)
      # Query object from consul
      consul_object = Diplomat::Kv.get kv_path
      return consul_object unless inflate

      # Inflate with gzip
      object_stream = StringIO.new consul_object
      gzip_stream = Zlib::GzipReader.new object_stream
      gzip_stream.read
    end
  end
end

