class CreateAuctions < ActiveRecord::Migration[5.1]
  def change
    create_table :auctions do |t|
      t.references :item, foreign_key: true
      t.integer :amount
      t.string :bidder
      t.decimal :bid

      t.timestamps
    end
  end
end
