class SysGroup < ActiveRecord::Base
  has_and_belongs_to_many :sys_permissions
 
  validates :description, presence: true, uniqueness: true
end
