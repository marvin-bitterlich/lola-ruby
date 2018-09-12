require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  test "starting an auction" do
    item = Item.create!(name: 'TestItem', amount: 5)
    auction = item.start_auction(amount=1, start_bid=-1)
    puts auction.to_json
    assert true
  end
end
