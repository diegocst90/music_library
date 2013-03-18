class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, :null=>false, :index=>{:unique=>true}

      t.timestamps
    end
  end
end
