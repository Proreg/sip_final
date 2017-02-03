class HrEmployee < ActiveRecord::Base
  belongs_to :hr_sector  #Keep in separated lines, when put together rake throws an exception
  belongs_to :sys_city 
  belongs_to :hr_marital_status
  belongs_to :hr_blood_type
  belongs_to :hr_position
  belongs_to :hr_insurance_plan
  belongs_to :hr_schooling_level

  
  has_one :sys_user
  has_many :hr_employee_phones
  has_many :hr_relatives
   
  # Does not validate :hr_insurance_plan, :sus, :reservista, :obs, :house_number, :complement, :active
  validates :extension_line, :cpf, :rg, :pis, :cts, :titulo_eleitor, :email, presence: true, uniqueness: true # present and unique

  validates :email_proreg, :locker_code, uniqueness: true
  
  validates :name, :date_of_birth, :serie_cts, :gender, :smoker, :hr_sector_id, :sys_city_id,
  :hr_marital_status_id, :hr_blood_type_id, :hr_position_id,:hr_schooling_level_id, :neighborhood,
  :access_code, :zip_code, :address, presence: true #just present, only field which is not verified is 'date_inactive' 

  validates :hr_sector, :sys_city, :hr_marital_status, :hr_blood_type, :hr_position,:hr_schooling_level, presence: true #validates if the foreign key is valid
end