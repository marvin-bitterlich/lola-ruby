json.extract! item, :id, :price, :name, :amount, :created_at, :updated_at
json.url item_url(item, format: :json)
