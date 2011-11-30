require 'singleton'

# very simple implementation of a storage for uuids
# not production ready
class UuidPool
  include Singleton

  def initialize
    @pool = Set.new
  end
  def add uuid
    @pool.add uuid
  end

  def seen? uuid
    @pool.include? uuid
  end

  def clear
    @pool = Set.new
  end
end