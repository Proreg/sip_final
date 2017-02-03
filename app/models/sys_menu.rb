class SysMenu < ActiveRecord::Base
  #belongs_to :sys_group
 # belongs_to :sys_menu
  
  validates :description, presence: true
end
