require "./spec_helper"

describe Digests do
  it "works" do
    true.should eq(true)
  end

  it "logical_path" do
    Digests.init
    digested_path = Digests.logical_path("/js/app.js")
    digested_path.should be_truthy
    digested_path.not_nil!.should eq("/js/app-42a314210f311e84f2dc144cbddeaac9.js")
  end
end
