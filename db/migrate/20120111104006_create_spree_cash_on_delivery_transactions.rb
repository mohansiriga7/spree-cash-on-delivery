class CreateSpreeCashOnDeliveryTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_cash_on_delivery_transactions do |t|
      t.string :state
      t.decimal :amount, :scale => 2, :precision => 8
      t.timestamps
    end
  end
end
