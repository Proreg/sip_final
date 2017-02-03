class HrSector < ActiveRecord::Base
  has_many :employees

  validates :description, presence: true, uniqueness: true
end
