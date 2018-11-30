class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :genre
      t.integer :age

      t.timestamps
    end
  end
end
