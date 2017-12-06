require "spec_helper"

RSpec.describe Lola do
  it "has a version number" do
    expect(Lola::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
