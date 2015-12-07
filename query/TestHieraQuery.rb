#
# Some basic tests for the HieraQuery class
#
require_relative "HieraQuery"
require "test/unit"

class TestHieraQuery < Test::Unit::TestCase

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::WARN
  # define your query host here
  @@uri = 'http://puppetmaster:8800'
  
  # Query the defined test url
  def test_target
    value = HieraQuery.query("#{@@uri}/test/ping")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_equal('ping', value['value'])
  end

  # Query a value without param
  def test_value
    value = HieraQuery.query("#{@@uri}/hiera/common")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_equal('some value', value['value'])
  end

  # Query a value with kernel as selector
  def test_value_specific
    value = HieraQuery.query("#{@@uri}/hiera/specific?kernel=Linux")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_equal('Linux', value['value'])
    value = HieraQuery.query("#{@@uri}/hiera/specific?kernel=windows")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_equal('windows', value['value'])
  end

  # Query for an array result 
  def test_array
    value = HieraQuery.query("#{@@uri}/hiera/array/common?kernel=Linux")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_kind_of(Array, value['value'])
    value = HieraQuery.query("#{@@uri}/hiera/array/common?kernel=windows")
    @@logger.debug("test_target result -> #{value}")
    @@logger.debug("test_target result class -> #{value.class}")
    @@logger.debug("test_target result value -> #{value['value']}")
    assert_kind_of(Array, value['value'])
  end

  # Test a nil return
  def test_error
  assert_nil(HieraQuery.query("/hiera/unknown"))
  end

end