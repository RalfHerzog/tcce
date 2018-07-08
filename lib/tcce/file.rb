require_relative 'registration'
require_relative 'certificate'

module TCCE
  class File
    attr_accessor :json

    def to_s
      JSON.parse(json).pretty_print
    end

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
      json['DomainsCertificate']['Certs'].map do |cert|
        TCCE::Certificate.parse cert
      end
    end

    def http_challenge
      json['HTTPChallenge']
    end
  end
end