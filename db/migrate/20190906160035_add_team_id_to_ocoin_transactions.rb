class AddTeamIdToOcoinTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :ocoin_transactions, :team_id, :bigint
  end
end
