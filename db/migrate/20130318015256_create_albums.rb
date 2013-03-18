class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name, :null=>false
      t.references :genre, :null=>false
      t.references :artist, :null=>false
      t.integer :year
      t.string :image_url

      t.timestamps
    end
    add_index :albums, :genre_id
    add_index :albums, :artist_id
  end
end
