class Item < ApplicationRecord
  define_specification do
    define :amount_negative, :boolean do
      :amount < 0
    end
    trigger :amount_negative, 'Amount can not be negative!'
  end
end
