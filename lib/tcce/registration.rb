module TCCE
  class Registration
    attr_accessor :json

    def self.parse(content)
      file = TCCE::Registration.new
      file.json = content
      file
    end

    def uri
      json['uri']
    end

    def status
      json['body']['status']
    end

    def contact
      contacts.first
    end

    def contacts
      json['body']['contact'].map do |contact|
        contact = contact[7..-1] if contact.start_with? 'mailto:'
        contact
      end
    end
  end
end