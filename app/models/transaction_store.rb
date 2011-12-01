# a very simple approximation of a data store

require 'singleton'
class TransactionStore
  include Singleton

  def initialize
    @store = Hash.new
  end
  def store key, obj
    @store[key] = obj
  end

  def get key
    @store[key]

  end
end