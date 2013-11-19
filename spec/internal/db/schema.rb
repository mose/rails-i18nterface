# encoding: utf-8

ActiveRecord::Schema.define do
# rubocop : disable all

  create_table "article", force: true do |t|
    t.string   "title", :null => false
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                              default: true
  end

  create_table "topics", force: true do |t|
    t.string   "title", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end
# rubocop : enable all

end
