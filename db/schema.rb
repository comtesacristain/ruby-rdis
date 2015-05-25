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

ActiveRecord::Schema.define(version: 20150525061913) do

  create_table "borehole_duplicates", force: :cascade do |t|
    t.integer  "borehole_id"
    t.integer  "duplicate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "borehole_duplicates", ["borehole_id"], name: "index_borehole_duplicates_on_borehole_id"
  add_index "borehole_duplicates", ["duplicate_id"], name: "index_borehole_duplicates_on_duplicate_id"

  create_table "borehole_entity_attributes", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "attribno"
    t.integer  "eno"
    t.string   "attr"
    t.float    "num_value"
    t.string   "text_value"
    t.date     "date_value"
    t.integer  "borehole_id"
  end

  add_index "borehole_entity_attributes", ["eno"], name: "index_borehole_entity_attributes_on_eno"

  create_table "borehole_mineral_attributes", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "attribno"
    t.integer  "eno"
    t.string   "attr"
    t.float    "num_value"
    t.string   "text_value"
    t.date     "date_value"
    t.integer  "borehole_id"
  end

  add_index "borehole_mineral_attributes", ["eno"], name: "index_borehole_mineral_attributes_on_eno"

  create_table "borehole_samples", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "sampleno"
    t.integer  "eno"
    t.string   "sampleid"
    t.string   "sample_type"
    t.float    "top_depth"
    t.float    "base_depth"
    t.integer  "parent"
    t.string   "originator"
    t.date     "acquiredate"
    t.string   "geom_original"
    t.integer  "borehole_id"
  end

  add_index "borehole_samples", ["eno"], name: "index_borehole_samples_on_eno"

  create_table "borehole_wells", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "eno"
    t.string   "welltype"
    t.string   "purpose"
    t.string   "on_off"
    t.string   "title"
    t.string   "classification"
    t.string   "status"
    t.float    "ground_elev"
    t.string   "operator"
    t.string   "uno"
    t.date     "start_date"
    t.date     "completion_date"
    t.string   "comments"
    t.float    "total_depth"
    t.string   "originator"
    t.integer  "origno"
    t.integer  "borehole_id"
  end

  add_index "borehole_wells", ["eno"], name: "index_borehole_wells_on_eno"

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
    t.string   "eid_qualifier"
    t.string   "geom"
  end

  add_index "boreholes", ["eno"], name: "index_boreholes_on_eno"
  add_index "boreholes", ["entity_type"], name: "index_boreholes_on_entity_type"
  add_index "boreholes", ["entityid"], name: "index_boreholes_on_entityid"

  create_table "duplicates", force: :cascade do |t|
    t.string   "kind"
    t.string   "auto_remediation"
    t.string   "manual_remediation", default: "N"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "comments"
    t.string   "auto_approved"
    t.string   "alias_check"
  end

  create_table "handlers", force: :cascade do |t|
    t.string   "auto_remediation",   default: "NONE"
    t.string   "auto_transfer"
    t.string   "or_status",          default: "undetermined"
    t.string   "or_comment"
    t.integer  "borehole_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "or_transfer"
    t.string   "manual_remediation"
    t.integer  "manual_transfer"
  end

  add_index "handlers", ["auto_remediation"], name: "index_handlers_on_auto_remediation"
  add_index "handlers", ["borehole_id", "or_status"], name: "index_handlers_on_borehole_id_and_or_status"
  add_index "handlers", ["borehole_id"], name: "index_handlers_on_borehole_id"
  add_index "handlers", ["or_status"], name: "index_handlers_on_or_status"
  add_index "handlers", ["or_transfer"], name: "index_handlers_on_or_transfer"

end
