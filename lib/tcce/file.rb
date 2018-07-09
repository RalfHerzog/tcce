require_relative 'registration'
require_relative 'certificate'

module TCCE
  class File
    attr_accessor :json

    # def to_s
    #   JSON.pretty_generate json
    # end

    # Parse a file given by argument
    # @param [String] content the object contents
    # @return [TCCE::File]
    def self.parse(content)
      file = TCCE::File.new
      file.json = JSON.parse content
      file
    end

    def email
      json['Email']
    end

    def registration
      TCCE::Registration.parse json['Registration']
    end

    def private_key
      json['PrivateKey']
    end

    def certificates
      certs = []
      json['DomainsCertificate']['Certs'].each do |cert|
        certificate = TCCE::Certificate.parse cert
        certs << certificate
        yield certificate if block_given?
      end
      certs
    end

    def http_challenge
      json['HTTPChallenge']
    end
  end
end