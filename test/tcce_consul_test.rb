require 'test_helper'

class TCCEConsulTest < Minitest::Test
  def test_wrong_credentials
    assert_raises Diplomat::UnknownStatus, Faraday::ConnectionFailed do
      consul = TCCE::Consul.new ENV.fetch('CONSUL_URL'),
                          'EmptyToken',
                          ENV.fetch('CONSUL_PATH')
      consul.get
    end
  end

  def test_get
    consul = TCCE::Consul.new ENV.fetch('CONSUL_URL'),
                        ENV.fetch('CONSUL_TOKEN'),
                        ENV.fetch('CONSUL_PATH')
    assert !consul.get.empty?
  end
end
