class CreateOcoinTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :ocoin_transactions do |t|
      t.integer :points
      t.text :message
    end
  end
end
