class Employee < ActiveRecord::Base
  validates :extension_line, :cpf,:rg, presence: true, uniqueness: true # present and unique
  validates :name, :date_of_birth, :hiring_date, :sector, presence: true #just present, only field which is not verified is 'date_inactive' 

  belongs_to :sector
end
