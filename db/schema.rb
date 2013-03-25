# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130318015506) do

  create_table "artists", :force => true do |t|
    t.string   "name",                          :null => false
    t.boolean  "deleted",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.index ["name"], :name => "index_artists_on_name", :unique => true
  end

  create_table "genres", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "description"
    t.boolean  "deleted",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.index ["name"], :name => "index_genres_on_name", :unique => true
  end

  create_table "albums", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "genre_id",                      :null => false
    t.integer  "artist_id",                     :null => false
    t.integer  "year"
    t.string   "image_url"
    t.boolean  "deleted",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.index ["genre_id"], :name => "fk__albums_genre_id"
    t.index ["artist_id"], :name => "fk__albums_artist_id"
    t.index ["genre_id"], :name => "index_albums_on_genre_id"
    t.index ["artist_id"], :name => "index_albums_on_artist_id"
    t.foreign_key ["artist_id"], "artists", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_albums_artist_id"
    t.foreign_key ["genre_id"], "genres", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_albums_genre_id"
  end

  create_table "songs", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "n_album"
    t.string   "duration",                      :null => false
    t.integer  "rating",     :default => 0
    t.integer  "album_id",                      :null => false
    t.boolean  "deleted",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.index ["album_id"], :name => "fk__songs_album_id"
    t.foreign_key ["album_id"], "albums", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_songs_album_id"
  end

end
