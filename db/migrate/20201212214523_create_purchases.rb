class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :symbol
      t.decimal :cost_per
      t.decimal :amount
      t.decimal :fee
      t.decimal :total_cost
      t.string :description

      t.timestamps
    end
    add_index :purchases, :user_id
  end
end
