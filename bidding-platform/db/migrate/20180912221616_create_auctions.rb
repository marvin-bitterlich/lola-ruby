class CreateAuctions < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :amount

      t.timestamps
    end
    create_table :auctions do |t|
      t.references :item, foreign_key: true
      t.integer :amount
      t.decimal :bid
      t.string :bidder

      t.timestamps
    end
  end
end
