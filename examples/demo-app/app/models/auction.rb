class Auction < ApplicationRecord
  belongs_to :item
  define_specification do
    define :amount_too_small, :boolean do
      :amount < 1
    end
    trigger :amount_too_small, 'Amount needs to be positive!'
    define :bid_negative, :boolean do
      :bid < 0
    end
    trigger :bid_negative, 'Bid can not be negative!'
    define :bid_not_bigger, :boolean do
      :bid <= look_back(:bid, 1, -1)
    end
    trigger :bid_smaller, 'Bid needs to be bigger than previous bid!'
  end
end
