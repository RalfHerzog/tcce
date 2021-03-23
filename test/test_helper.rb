# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'tcce'

require 'minitest/autorun'

ENV['CONSUL_URL'] ||= 'http://localhost:8300'
ENV['CONSUL_TOKEN'] ||= 'xxxxxxxx-yyyy-zzzz-1111-222222222222'
ENV['CONSUL_PATH'] ||= 'traefik/acme/account/object'
