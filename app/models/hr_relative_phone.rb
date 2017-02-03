class HrRelativePhone < ActiveRecord::Base
  belongs_to :sys_telephone_type
  belongs_to :hr_relative

  validates :phone_number, :area_code, presence: true
  validates  :sys_telephone_type, :hr_relative, presence: true #validates FK table if present
end
