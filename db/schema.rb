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

ActiveRecord::Schema.define(:version => 20110608144055) do

  create_table "amounts", :force => true do |t|
    t.float    "ingredientAmount", :default => 0.0
    t.integer  "ingredient_id",    :default => 0
    t.integer  "meal_id",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "brand"
    t.integer  "category_id", :default => 1
    t.float    "protein",     :default => 0.0
    t.float    "carbs",       :default => 0.0
    t.float    "fat",         :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meals", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.time     "time"
    t.boolean  "dayOn",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
