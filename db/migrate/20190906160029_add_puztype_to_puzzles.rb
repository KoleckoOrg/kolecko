class AddPuztypeToPuzzles < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :puztype, :integer
  end
end
