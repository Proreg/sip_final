class InsSubInspectorPhone < ActiveRecord::Base
  belongs_to :sys_telephone_type
  belongs_to :ins_sub_inspector
  
  validates :phone_number, :area_code, :sys_telephone_type_id, :ins_sub_inspector_id, presence: true
  validates :sys_telephone_type, :ins_sub_inspector, presence: true
end
