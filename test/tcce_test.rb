require 'test_helper'

class TCCETest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TCCE::VERSION
  end
end
