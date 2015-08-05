class CreateBoreholeDirSurvey < ActiveRecord::Migration
  def change
    create_table :borehole_dir_surveys do |t|
      t.string :usi
      t.string :sidetrack
      t.string :survey_id
      t.string :source
      t.string :azimuth_north_type
      t.decimal :base_depth
      t.string :base_depth_ouom
      t.string :compute_method
      t.string :coord_system_id
      t.string :dir_survey_class
      t.string :ew_direction
      t.decimal :magnetic_declination
      t.string :offset_north_type
      t.decimal :plane_of_proposal
      t.string :record_mode
      t.string :remark
      t.string :source_document
      t.string :survey_company
      t.datetime :survey_date
      t.string :survey_quality
      t.string :survey_type
      t.decimal :top_depth
      t.string :top_depth_ouom
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
    end
  end
end
