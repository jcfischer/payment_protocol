require 'spec_helper'


describe UuidPool do

  context "#seen?" do
    let(:pool) { UuidPool.instance }

    it "returns true if uuid already seen" do
      pool.add :some_uuid_value
      pool.seen?(:some_uuid_value).should be_true
    end

    it "returns false if not seen" do
      pool.add :some_uuid_value
      pool.seen?(:other_uuid_value).should be_false
    end
  end

end