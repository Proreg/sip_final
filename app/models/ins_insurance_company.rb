class InsInsuranceCompany < ActiveRecord::Base
  has_many :ins_inspector
  belongs_to :sys_city

  # does not validate state_registration, status, notes
  validates :commercial_name, :address, :zip_code, :neighborhood, :register_date,  presence: true
  validates :corporate_name, :cnpj, :email, presence: true, uniqueness: true
  validates :sys_city, presence: true
end
