class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, :null=>false, :index=>{:unique=>true}
      t.boolean :deleted, :default=>false
      t.timestamps
    end
  end
end
