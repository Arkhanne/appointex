class ChangeGenreColumnNameInUsers < ActiveRecord::Migration[5.2]
  def change
      rename_column :users, :genre, :gender
  end
end
