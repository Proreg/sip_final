class InsInspXSubInspector < ActiveRecord::Base
  belongs_to :ins_inspector
  belongs_to :ins_sub_inspector
  
  validates :ins_inspector, :ins_sub_inspector, presence: true
end
