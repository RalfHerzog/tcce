require 'test_helper'

class TCCEConsulTest < Minitest::Test
  def setup
    path = ::File.expand_path ::File.join('files', 'object.json'), __dir__
    string = ::File.read path

    @file = TCCE::File.parse string
    @registration = @file.registration
  end

  def test_file
    assert @file.email
    assert @file.email.is_a? String
    assert @file.email.include? '@'

    assert @file.http_challenge.nil?

    assert @file.private_key
    assert @file.private_key.is_a? String
  end

  def test_registration
    assert @registration.is_a? TCCE::Registration

    # Uri
    assert @registration.uri
    assert @registration.uri.start_with? 'https://acme-v02.api.letsencrypt.org/acme/acct/'

    # Status
    assert @registration.status
    assert_equal 'valid', @registration.status

    # Contacts
    assert @registration.contacts

    assert @registration.contacts.is_a? Array
    assert !@registration.contacts.empty?

    assert @registration.contact.is_a? String
    assert_equal @registration.contact, @registration.contacts.first
  end

  def test_certificates
    # Yield by block
    @file.certificates do |certificate|
      assert certificate.is_a? TCCE::Certificate
    end

    certificates = @file.certificates
    assert certificates
    assert certificates.is_a? Array

    certificates.each do |certificate|
      assert certificate.is_a? TCCE::Certificate

      # Domain
      assert certificate.domain
      assert certificate.domain.is_a? String

      # SANs
      (certificate.sans || []).each do |san|
        assert san.is_a? String
      end

      # Certificate
      cert = certificate.certificate
      assert cert.is_a? OpenSSL::X509::Certificate

      # Private key
      key = certificate.private_key
      assert key.is_a? OpenSSL::PKey::RSA

      # Verify
      assert cert.verify key
    end
  end
end
