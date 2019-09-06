class AddTimestampsToOcoinTransactions < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :ocoin_transactions, null: false, default: -> { 'NOW()' }
  end
end
