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

ActiveRecord::Schema.define(version: 20150508074013) do

  create_table "borehole_duplicates", force: :cascade do |t|
    t.integer  "borehole_id"
    t.integer  "duplicate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "borehole_duplicates", ["borehole_id"], name: "index_borehole_duplicates_on_borehole_id"
  add_index "borehole_duplicates", ["duplicate_id"], name: "index_borehole_duplicates_on_duplicate_id"

  create_table "boreholes", force: :cascade do |t|
    t.integer  "eno"
    t.string   "entityid"
    t.string   "entity_type"
    t.float    "x"
    t.float    "y"
    t.float    "z"
    t.string   "access_code"
    t.date     "confid_until"
    t.string   "qa_status_code"
    t.string   "qadate"
    t.integer  "acquisition_methodno"
    t.string   "geom_original"
    t.integer  "parent"
    t.string   "remark"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "action"
    t.integer  "data_transferred_to"
    t.string   "eid_qualifier"
  end

  create_table "duplicates", force: :cascade do |t|
    t.string   "kind"
    t.string   "has_remediation"
    t.string   "qaed"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "handlers", force: :cascade do |t|
    t.string   "auto_remediation"
    t.string   "auto_transfer"
    t.string   "olr_status"
    t.string   "olr_comment"
    t.integer  "borehole_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "olr_transfer"
    t.string   "manual_remediation"
    t.integer  "manual_transfer"
  end

  add_index "handlers", ["borehole_id"], name: "index_handlers_on_borehole_id"

end
