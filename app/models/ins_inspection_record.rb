class InsInspectionRecord < ActiveRecord::Base
  belongs_to :ins_record_type
  belongs_to :ins_inspection
  belongs_to :ins_inspector
  belongs_to :sys_user
end
