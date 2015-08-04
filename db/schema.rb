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

ActiveRecord::Schema.define(version: 20150804035134) do

  create_table "borehole_duplicates", force: :cascade do |t|
    t.integer  "borehole_id"
    t.integer  "duplicate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "borehole_duplicates", ["borehole_id"], name: "index_borehole_duplicates_on_borehole_id"
  add_index "borehole_duplicates", ["duplicate_id"], name: "index_borehole_duplicates_on_duplicate_id"

  create_table "borehole_entity_attributes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "borehole_mineral_attributes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "borehole_samples", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "sampleno"
    t.integer  "eno"
    t.string   "sampleid"
    t.string   "sample_type"
    t.decimal  "top_depth"
    t.decimal  "base_depth"
    t.integer  "parent"
    t.string   "access_code"
    t.datetime "entrydate"
    t.string   "enteredby"
    t.datetime "lastupdate"
    t.string   "updatedby"
    t.datetime "qadate"
    t.string   "qaby"
    t.string   "qa_status_code"
    t.string   "activity_code"
    t.string   "originator"
    t.datetime "acquiredate"
    t.integer  "ano"
    t.string   "geom"
    t.string   "comments"
    t.string   "source"
    t.integer  "procedureno"
    t.integer  "origno"
    t.datetime "confid_until"
    t.string   "geom_original"
    t.integer  "accuracy"
    t.integer  "elev_accuracy"
    t.integer  "acquisition_methodno"
    t.string   "acquisition_scale"
    t.string   "method"
    t.string   "countryid"
    t.string   "stateid"
    t.string   "onshore_flag"
    t.integer  "prov_eno"
    t.integer  "intervalno"
    t.integer  "sample_type_new"
    t.integer  "sampling_method"
    t.integer  "material_class"
    t.string   "igsn"
    t.decimal  "mass"
    t.string   "mass_uom"
    t.string   "specimen_location"
    t.datetime "specimen_location_date"
  end

  create_table "borehole_sidetracks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "borehole_stratigraphies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "borehole_well_confids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.decimal  "ground_elev"
    t.string   "operator"
    t.string   "uno"
    t.datetime "start_date"
    t.datetime "completion_date"
    t.string   "comments"
    t.string   "access_code"
    t.integer  "ano"
    t.datetime "entrydate"
    t.string   "enteredby"
    t.datetime "lastupdate"
    t.string   "updatedby"
    t.decimal  "total_depth"
    t.string   "originator"
    t.datetime "qadate"
    t.string   "qaby"
    t.string   "qa_status_code"
    t.string   "activity_code"
    t.string   "file_no"
    t.string   "state"
    t.datetime "confid_until"
    t.integer  "origno"
  end

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
    t.string   "manual_remediation",   default: "N"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "comments"
    t.string   "auto_approved"
    t.string   "alias_check"
    t.integer  "keep"
    t.integer  "geom_original"
    t.integer  "eid_qualifier"
    t.integer  "remark"
    t.integer  "access_code"
    t.integer  "acquisition_methodno"
    t.integer  "welltype"
    t.integer  "purpose"
    t.integer  "title"
    t.integer  "classification"
    t.integer  "status"
    t.integer  "ground_elev"
    t.integer  "operator"
    t.integer  "uno"
    t.integer  "start_date"
    t.integer  "completion_date"
    t.integer  "total_depth"
    t.integer  "originator"
    t.integer  "origno"
    t.integer  "on_off"
    t.string   "resolved_name"
    t.string   "determination"
    t.string   "resolved"
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
    t.string   "or_final_comment"
    t.string   "or_reference"
  end

  add_index "handlers", ["auto_remediation"], name: "index_handlers_on_auto_remediation"
  add_index "handlers", ["borehole_id", "or_status"], name: "index_handlers_on_borehole_id_and_or_status"
  add_index "handlers", ["borehole_id"], name: "index_handlers_on_borehole_id"
  add_index "handlers", ["or_status"], name: "index_handlers_on_or_status"
  add_index "handlers", ["or_transfer"], name: "index_handlers_on_or_transfer"

end
