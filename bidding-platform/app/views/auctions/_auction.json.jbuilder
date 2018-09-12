json.extract! auction, :id, :item_id, :amount, :bid, :bidder, :created_at, :updated_at
json.url auction_url(auction, format: :json)
