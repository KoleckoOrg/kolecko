class CreateTeamMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :team_messages do |t|
      t.references :team, foreign_key: true
      t.references :message, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
