class AddPointsToPuzzles < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :points, :integer
  end
end
