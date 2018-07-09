require 'base64'
require 'openssl'

module TCCE
  class Certificate
    attr_accessor :json

    # def to_s
    #   JSON.pretty_generate json
    # end

    def self.parse(content)
      file = TCCE::Certificate.new
      file.json = content
      file
    end

    def domain
      json['Domains']['Main']
    end

    def sans
      json['Domains']['SANs']
    end

    def certificate
      certificate = Base64.decode64 json['Certificate']['Certificate']
      OpenSSL::X509::Certificate.new certificate
    end

    def private_key
      private_key = Base64.decode64 json['Certificate']['PrivateKey']
      OpenSSL::PKey::RSA.new private_key
    end

    # alias names sans
  end
end