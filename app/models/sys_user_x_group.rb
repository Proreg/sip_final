class SysUserXGroup < ActiveRecord::Base
  belongs_to :sys_group
  belongs_to :sys_user
  
  validates :sys_group, :sys_user, presence: true
end
