class ChangeGenreToBeIntegerInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :genre, 'integer USING CAST(genre AS integer)'
  end
end
