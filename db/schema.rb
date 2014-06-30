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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140630015429) do

  create_table "games", force: true do |t|
    t.integer  "room"
    t.integer  "player"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pit_one"
    t.integer  "pit_two"
    t.integer  "bat_one"
    t.integer  "bat_two"
    t.integer  "wumpit"
    t.integer  "arrow"
    t.integer  "counter"
    t.integer  "timer"
  end

  create_table "high_scores", force: true do |t|
    t.string   "name"
    t.integer  "moves"
    t.integer  "seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
  end

end
