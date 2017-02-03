class ChangeUserPassword
  def initialize(user_id)
    @user = SysUser.find(user_id)
  end
  def perform
    pass = GenerateUser.new.password_generator 

    @user.update(password: pass)

    SysUserMailer.login_info(@user, pass).deliver_later
  end
end