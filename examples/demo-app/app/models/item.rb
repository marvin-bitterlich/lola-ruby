class Item < ApplicationRecord
  has_many :auctions
  define_specification do
    define :amount_negative, :boolean do
      :amount < 0
    end
    trigger :amount_negative, 'Amount can not be negative!'
  end

  def start_auction(amount=1, start_bid= 0.0)
    Auction.create(item: self, amount: amount, bid: start_bid, bidder: '')
  end
end
