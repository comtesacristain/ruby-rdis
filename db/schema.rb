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

ActiveRecord::Schema.define(version: 20150818052013) do

  create_table "borehole_bloblinks", force: :cascade do |t|
    t.integer  "bloblinkno"
    t.string   "source_owner"
    t.string   "source_table"
    t.string   "source_column"
    t.integer  "source_no"
    t.integer  "blobno"
    t.string   "remark"
    t.string   "access_code"
    t.integer  "ano"
    t.datetime "entrydate"
    t.string   "enteredby"
    t.datetime "lastupdate"
    t.string   "updatedby"
    t.datetime "qadate"
    t.string   "qaby"
    t.string   "qa_status_code"
    t.string   "activity_code"
  end

  create_table "borehole_core_data", force: :cascade do |t|
    t.string  "uno"
    t.string  "name"
    t.string  "bmr_file_no"
    t.string  "psla_no"
    t.string  "location"
    t.string  "legsln"
    t.decimal "num_boxes"
    t.decimal "total_boxes"
    t.decimal "num_boxes_prev"
    t.string  "print_label"
    t.string  "t_type"
    t.integer "eno"
    t.string  "access_code"
    t.integer "ano"
  end

  create_table "borehole_dir_survey_stations", force: :cascade do |t|
    t.string   "usi"
    t.string   "sidetrack"
    t.string   "survey_id"
    t.string   "source"
    t.string   "station_id"
    t.decimal  "azimuth"
    t.string   "azimuth_ouom"
    t.decimal  "dog_leg_severity"
    t.decimal  "easting"
    t.decimal  "ellipsoid_elev"
    t.string   "ew_direction"
    t.decimal  "inclination"
    t.string   "inclination_ouom"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.decimal  "northing"
    t.string   "ns_direction"
    t.string   "point_type"
    t.string   "remark"
    t.decimal  "sealevel_elev"
    t.decimal  "station_md"
    t.string   "station_md_ouom"
    t.decimal  "station_tvd"
    t.string   "station_tvd_ouom"
    t.decimal  "vertical_section"
    t.string   "vertical_section_ouom"
    t.decimal  "x_offset"
    t.string   "x_offset_ouom"
    t.decimal  "y_offset"
    t.string   "y_offset_ouom"
    t.integer  "zone"
    t.datetime "row_changed_date"
    t.string   "row_changed_by"
    t.integer  "eno"
    t.datetime "entrydate"
    t.string   "enteredby"
    t.datetime "lastupdate"
    t.string   "updatedby"
    t.datetime "qadate"
    t.string   "qaby"
    t.string   "qa_status_code"
    t.string   "access_code"
    t.integer  "ano"
    t.integer  "sourceno"
    t.string   "source_comment"
    t.string   "source_section"
    t.string   "qa_comment"
  end

  create_table "borehole_dir_surveys", force: :cascade do |t|
    t.string   "usi"
    t.string   "sidetrack"
    t.string   "survey_id"
    t.string   "source"
    t.string   "azimuth_north_type"
    t.decimal  "base_depth"
    t.string   "base_depth_ouom"
    t.string   "compute_method"
    t.string   "coord_system_id"
    t.string   "dir_survey_class"
    t.string   "ew_direction"
    t.decimal  "magnetic_declination"
    t.string   "offset_north_type"
    t.decimal  "plane_of_proposal"
    t.string   "record_mode"
    t.string   "remark"
    t.string   "source_document"
    t.string   "survey_company"
    t.datetime "survey_date"
    t.string   "survey_quality"
    t.string   "survey_type"
    t.decimal  "top_depth"
    t.string   "top_depth_ouom"
    t.datetime "row_changed_date"
    t.string   "row_changed_by"
    t.integer  "eno"
    t.datetime "entrydate"
    t.string   "enteredby"
    t.datetime "lastupdate"
    t.string   "updatedby"
    t.datetime "qadate"
    t.string   "qaby"
    t.string   "qa_status_code"
    t.string   "access_code"
    t.integer  "ano"
  end

  create_table "borehole_duplicates", force: :cascade do |t|
    t.integer  "borehole_id"
    t.integer  "duplicate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "borehole_duplicates", ["borehole_id"], name: "index_borehole_duplicates_on_borehole_id"
  add_index "borehole_duplicates", ["duplicate_id"], name: "index_borehole_duplicates_on_duplicate_id"

  create_table "borehole_entity_attributes", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "eno"
    t.string   "a_attribute"
    t.decimal  "num_value"
    t.datetime "date_value"
    t.string   "access_code"
    t.date     "entrydate"
    t.string   "enteredby"
    t.date     "lastupdate"
    t.string   "updatedby"
    t.string   "text_value"
    t.integer  "ano"
    t.string   "remark"
    t.integer  "attribno"
    t.date     "confid_until"
  end

  create_table "borehole_mineral_attributes", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "eno"
    t.string   "a_attribute"
    t.decimal  "num_value"
    t.datetime "date_value"
    t.string   "uom"
    t.string   "access_code"
    t.date     "entrydate"
    t.string   "enteredby"
    t.date     "lastupdate"
    t.string   "updatedby"
    t.string   "text_value"
    t.integer  "ano"
    t.string   "comments"
    t.integer  "attribno"
    t.integer  "year"
    t.date     "confid_until"
  end

  create_table "borehole_porperm_ones", force: :cascade do |t|
    t.string  "well"
    t.string  "andate"
    t.string  "genfile"
    t.string  "wellfile"
    t.string  "remarks"
    t.string  "uno"
    t.decimal "latit"
    t.decimal "longit"
    t.integer "eno"
    t.string  "access_code"
    t.integer "ano"
  end

  create_table "borehole_porperm_picks", force: :cascade do |t|
    t.string  "uno"
    t.string  "pick"
    t.integer "eno"
    t.string  "access_code"
    t.integer "ano"
  end

  create_table "borehole_porperm_twos", force: :cascade do |t|
    t.string  "well"
    t.integer "coreno"
    t.string  "matrix"
    t.string  "grain"
    t.string  "comments"
    t.decimal "poroh"
    t.decimal "porov"
    t.decimal "permh"
    t.decimal "permv"
    t.decimal "depav"
    t.decimal "porav"
    t.string  "uno"
    t.string  "rock1"
    t.string  "rock2"
    t.string  "pick"
    t.string  "age1"
    t.string  "age2"
    t.string  "unit"
    t.decimal "depth"
    t.string  "basin"
    t.integer "eno"
    t.string  "access_code"
    t.integer "ano"
  end

  create_table "borehole_reflinks", force: :cascade do |t|
    t.integer  "eno"
    t.integer  "refid"
    t.string   "enteredby"
    t.datetime "entrydate"
    t.datetime "lastupdate"
    t.string   "updatedby"
  end

  create_table "borehole_remarkws", force: :cascade do |t|
    t.string   "uno"
    t.string   "code"
    t.integer  "sequence"
    t.string   "remark"
    t.datetime "rec_date"
    t.datetime "updated"
    t.string   "db_source"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
  end

  create_table "borehole_resfacs_remarks", force: :cascade do |t|
    t.string  "uno"
    t.string  "code"
    t.decimal "seq_no"
    t.string  "remark"
    t.string  "sidetrack"
    t.integer "eno"
    t.string  "access_code"
    t.integer "ano"
    t.decimal "rfs_rmksno"
  end

  create_table "borehole_resultws", force: :cascade do |t|
    t.string   "uno"
    t.string   "t_type"
    t.string   "reference"
    t.string   "location"
    t.datetime "release"
    t.string   "remark"
    t.datetime "rec_date"
    t.datetime "updated"
    t.string   "db_source"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
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
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "uno"
    t.string   "sidetrack"
    t.decimal  "ko_depth"
    t.decimal  "td_driller"
    t.decimal  "td_logs"
    t.decimal  "tvd"
    t.decimal  "metres_drilled"
    t.string   "db_source"
    t.datetime "rec_date"
    t.datetime "updated"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
  end

  create_table "borehole_stratigraphies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "picked"
    t.string   "age1"
    t.string   "qual1"
    t.string   "age2"
    t.string   "qual2"
    t.string   "unit"
    t.decimal  "top_meas_depth_m"
    t.decimal  "elevation"
    t.decimal  "meas_thickness_m"
    t.string   "code"
    t.datetime "updated"
    t.datetime "rec_date"
    t.string   "db_source"
    t.integer  "unitno"
    t.decimal  "top_vert_depth_m"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
    t.string   "unit_qualifier"
    t.decimal  "base_meas_depth_m"
    t.integer  "sourceno"
    t.string   "source_comment"
    t.string   "enteredby"
    t.string   "updatedby"
    t.string   "remarks"
    t.integer  "sampleno"
    t.string   "pref_alt"
  end

  create_table "borehole_wdata_ones", force: :cascade do |t|
    t.string   "uno"
    t.string   "code"
    t.string   "testtype"
    t.decimal  "top"
    t.decimal  "bottom"
    t.integer  "samples"
    t.string   "remark"
    t.datetime "rec_date"
    t.datetime "updated"
    t.string   "db_source"
    t.string   "sidetrack"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
  end

  create_table "borehole_wdata_twos", force: :cascade do |t|
    t.string   "uno"
    t.string   "code"
    t.integer  "sequence"
    t.decimal  "top"
    t.decimal  "bottom"
    t.decimal  "recovery"
    t.datetime "rec_date"
    t.datetime "updated"
    t.string   "db_source"
    t.string   "sidetrack"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
  end

  create_table "borehole_well_confids", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.decimal  "eno"
    t.string   "confid"
    t.string   "phase"
    t.datetime "date_created"
    t.string   "accumulation"
    t.string   "acreage_summary"
    t.string   "actual_well_purpose"
    t.string   "admin_reg"
    t.string   "admin_reg_abbrev"
    t.decimal  "associated_well_eno"
    t.string   "contractor"
    t.string   "cont_abbrev"
    t.string   "country"
    t.decimal  "der_ko_depth"
    t.decimal  "der_prop_total_depth"
    t.decimal  "der_tot_depth_sub_sea"
    t.string   "discovery"
    t.string   "disc_type"
    t.decimal  "drillers_total_depth"
    t.string   "drillers_total_depth_units"
    t.decimal  "easting"
    t.decimal  "elev"
    t.decimal  "est_cost"
    t.string   "facility"
    t.string   "file_number"
    t.string   "ga_basin"
    t.string   "ga_location"
    t.string   "ga_sub_basin"
    t.string   "ga_summary"
    t.string   "hc_show"
    t.string   "hole_class"
    t.string   "hole_name"
    t.string   "incl_type"
    t.string   "kb_rt"
    t.decimal  "kb_rt_height"
    t.decimal  "ko_depth"
    t.string   "ko_depth_units"
    t.string   "leg"
    t.string   "loggers_depth_units"
    t.decimal  "loggers_total_depth"
    t.decimal  "max_dev"
    t.string   "near_accumulation"
    t.decimal  "northing"
    t.string   "on_off"
    t.string   "operator"
    t.string   "operator_abbrev"
    t.string   "op_abn"
    t.string   "op_acn"
    t.string   "op_arbn"
    t.decimal  "orig_elev"
    t.string   "orig_elev_units_measure"
    t.string   "orig_geo_datum"
    t.decimal  "orig_kb_rt_height"
    t.string   "orig_kb_rt_height_units"
    t.decimal  "orig_lat_dec_degrees"
    t.decimal  "orig_lat_degrees"
    t.decimal  "orig_lat_minutes"
    t.decimal  "orig_lat_seconds"
    t.decimal  "orig_long_dec_degrees"
    t.decimal  "orig_long_degrees"
    t.decimal  "orig_long_minutes"
    t.decimal  "orig_long_seconds"
    t.decimal  "orig_td_easting"
    t.decimal  "orig_td_lat_dec_degrees"
    t.decimal  "orig_td_lat_deg"
    t.decimal  "orig_td_lat_min"
    t.decimal  "orig_td_lat_sec"
    t.decimal  "orig_td_long_dec_degrees"
    t.decimal  "orig_td_long_deg"
    t.decimal  "orig_td_long_min"
    t.decimal  "orig_td_long_sec"
    t.decimal  "orig_td_northing"
    t.decimal  "orig_td_zone"
    t.decimal  "parent_well_eno"
    t.string   "parent_well_name"
    t.string   "post_drill"
    t.decimal  "pref_total_depth"
    t.string   "pref_total_depth_units"
    t.string   "pre_drill"
    t.decimal  "prop_target_depth"
    t.string   "prop_target_depth_units"
    t.string   "reason_for_cessation"
    t.string   "rig_capacity"
    t.string   "rig_make"
    t.string   "rig_model"
    t.string   "rig_name"
    t.string   "rig_no"
    t.datetime "rig_release_date"
    t.string   "rig_type"
    t.string   "sidetrack_purpose"
    t.datetime "spud_date"
    t.decimal  "sub_cost"
    t.string   "subsidy"
    t.datetime "td_depth_date"
    t.decimal  "td_lat_dec_degrees"
    t.decimal  "td_long_dec_degrees"
    t.string   "tests_entered"
    t.string   "title"
    t.decimal  "total_depth"
    t.decimal  "tot_cost"
    t.decimal  "tvd_subsea"
    t.string   "tvd_subsea_units"
    t.decimal  "utm_zone"
    t.string   "v_dat_type"
    t.string   "wcr_basin"
    t.string   "wcr_location"
    t.string   "wcr_sub_basin"
    t.string   "wcr_summary"
    t.string   "weekly_comments"
    t.string   "well_abbreviation"
    t.string   "well_alias"
    t.string   "well_comm"
    t.decimal  "well_lat_dec_degrees"
    t.decimal  "well_long_dec_degrees"
    t.string   "well_objective"
    t.string   "well_purpose"
    t.string   "well_status"
    t.string   "well_summary"
    t.string   "well_uno"
    t.string   "zone"
    t.string   "proposed_rig_name"
    t.datetime "proposed_spud_date"
    t.datetime "proposed_td_date"
  end

  create_table "borehole_well_temps", force: :cascade do |t|
    t.string   "uno"
    t.string   "mud_comp"
    t.string   "tool"
    t.string   "temp_type"
    t.decimal  "depth"
    t.decimal  "rec_temp"
    t.decimal  "post_circ_time"
    t.decimal  "circ_time"
    t.string   "remark"
    t.string   "db_source"
    t.datetime "rec_date"
    t.datetime "updated"
    t.string   "sidetrack"
    t.integer  "diameter"
    t.string   "cased"
    t.decimal  "cased_to"
    t.decimal  "casing_size"
    t.string   "suite"
    t.string   "run"
    t.datetime "run_date"
    t.decimal  "gradient"
    t.integer  "eno"
    t.string   "access_code"
    t.integer  "ano"
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
    t.string   "restore",              default: "N"
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
    t.string   "final_status"
  end

  add_index "handlers", ["auto_remediation"], name: "index_handlers_on_auto_remediation"
  add_index "handlers", ["borehole_id", "or_status"], name: "index_handlers_on_borehole_id_and_or_status"
  add_index "handlers", ["borehole_id"], name: "index_handlers_on_borehole_id"
  add_index "handlers", ["or_status"], name: "index_handlers_on_or_status"
  add_index "handlers", ["or_transfer"], name: "index_handlers_on_or_transfer"

  create_table "porperm_ones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
