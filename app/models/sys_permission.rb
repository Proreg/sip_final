class SysPermission < ActiveRecord::Base
  has_many :sys_group
  has_many :sys_menu

  #validates :sys_group, presence: true
end
