class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name, :null=>false
      t.integer :n_album
      t.string :duration, :null=>false
      t.integer :rating, :default=>0
      t.references :album, :null=>false
      t.boolean :deleted, :default=>false
      t.timestamps
    end
  end
end
