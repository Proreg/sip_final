class HrRelative < ActiveRecord::Base
  belongs_to :hr_employee
  belongs_to :hr_relative_type

  # does not validate dependente
  validates :name, :date_of_birth, :gender, :cpf, :rg, presence: true
  validates :cpf, :rg, presence: true, uniqueness: true
  validates :hr_employee, :hr_relative_type, presence: true
end
