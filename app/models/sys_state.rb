class SysState < ActiveRecord::Base
  belongs_to :sys_country 
  
  validates :description, :UF, presence: true, uniqueness: true
  validates :sys_country_id, presence: true
  validates :sys_country, presence: true #validates if the sys country ID saved is valid in the sys_country table 
end
