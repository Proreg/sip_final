class InsInspectorPhone < ActiveRecord::Base
  belongs_to :sys_telephone_type
  belongs_to :ins_inspector
  
  validates :phone_number, :area_code, :sys_telephone_type_id, :ins_inspector_id, presence: true
  validates :sys_telephone_type, :ins_inspector, presence: true
end
