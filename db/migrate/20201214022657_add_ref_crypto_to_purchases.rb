class AddRefCryptoToPurchases < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchases, :crypto, null: false, foreign_key: true
  end
end
