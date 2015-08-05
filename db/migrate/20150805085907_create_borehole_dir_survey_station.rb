class CreateBoreholeDirSurveyStation < ActiveRecord::Migration
  def change
    create_table :borehole_dir_survey_stations do |t|
      t.string :usi
      t.string :sidetrack
      t.string :survey_id
      t.string :source
      t.string :station_id
      t.decimal :azimuth
      t.string :azimuth_ouom
      t.decimal :dog_leg_severity
      t.decimal :easting
      t.decimal :ellipsoid_elev
      t.string :ew_direction
      t.decimal :inclination
      t.string :inclination_ouom
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :northing
      t.string :ns_direction
      t.string :point_type
      t.string :remark
      t.decimal :sealevel_elev
      t.decimal :station_md
      t.string :station_md_ouom
      t.decimal :station_tvd
      t.string :station_tvd_ouom
      t.decimal :vertical_section
      t.string :vertical_section_ouom
      t.decimal :x_offset
      t.string :x_offset_ouom
      t.decimal :y_offset
      t.string :y_offset_ouom
      t.integer :zone
      t.datetime :row_changed_date
      t.string :row_changed_by
      t.integer :eno
      t.datetime :entrydate
      t.string :enteredby
      t.datetime :lastupdate
      t.string :updatedby
      t.datetime :qadate
      t.string :qaby
      t.string :qa_status_code
      t.string :access_code
      t.integer :ano
      t.integer :sourceno
      t.string :source_comment
      t.string :source_section
      t.string :qa_comment
    end
  end
end
