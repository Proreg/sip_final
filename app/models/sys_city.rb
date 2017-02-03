class SysCity < ActiveRecord::Base
  belongs_to :sys_state
  has_many :ins_inspection
  
  
  validates :description, presence: true
  validates :sys_state_id, presence: true
  validates :sys_state, presence: true #validates if the sys country ID saved is valid in the sys_country table 
end
