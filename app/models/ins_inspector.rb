class InsInspector < ActiveRecord::Base
   #Keep in separated lines, when put together rake throws an exception
  belongs_to :sys_city 
  has_many :ins_inspector_phone
  has_one :sys_user
  belongs_to :hr_employee
  
  validates :cpf, :rg, :email, presence: true, uniqueness: true # present and unique

  validates :name, :date_of_birth, :sys_city_id, :address, :neighborhood, :house_number,
  :zip_code, :address, presence: true #just present, only field which is not verified is 'date_inactive' 

  validates :sys_city, presence: true #validates if the foreign key is valid

end
