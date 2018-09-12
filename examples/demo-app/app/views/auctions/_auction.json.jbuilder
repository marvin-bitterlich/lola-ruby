json.extract! auction, :id, :item_id, :amount, :bidder, :bid, :created_at, :updated_at
json.url auction_url(auction, format: :json)
