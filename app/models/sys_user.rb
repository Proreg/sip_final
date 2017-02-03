class SysUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable,:registerable, :recoverable,:rememberable,
  devise :database_authenticatable, 
          :trackable, :validatable,:lockable, :timeoutable,
         :authentication_keys => [:login]
         
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  belongs_to :hr_employee
  belongs_to :ins_inspector
  
  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    } # etc.
    
  # Configure Devise to use username as reset password or confirmation keys  
  def self.find_first_by_auth_conditions(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
  else
    if conditions[:username].nil?
      where(conditions).first
    else
      where(username: conditions[:username]).first
    end
  end
 end
end
