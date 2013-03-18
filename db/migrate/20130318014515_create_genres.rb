class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name, :null=>false, :index=>{:unique=>true}
      t.string :description

      t.timestamps
    end
  end
end
