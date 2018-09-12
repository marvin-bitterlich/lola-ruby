class Auction < ApplicationRecord
  belongs_to :item
  define_specification do
    define :amount_too_small, :boolean do
      l(:amount) < 1
    end
    trigger :amount_too_small, 'Amount needs to be positive!'
    define :bid_negative, :boolean do
      l(:bid) < 0
    end
    trigger :bid_negative, 'Bid can not be negative!'
    define :bid_not_bigger, :boolean do
      l(:bid) <= look_back(:bid, 1, -1)
    end
    trigger :bid_not_bigger, 'Bid needs to be bigger than previous bid!'
  end
end
