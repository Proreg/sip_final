class SysUserMailer < ApplicationMailer
          
  def login_info(user, pw)
    @user = user
    @pw = pw
    if @user.try(:hr_employee).try(:email_proreg)
     mail to: @user.hr_employee.email_proreg,
      subject: "Login e Senha"
    elsif @user.try(:ins_inspector).try(:email)
     mail to: @user.ins_inspector.email,
     subject: "Login e Senha"
      
     puts @user.ins_inspector.email
    end    
     mail bcc: "ti@proreg.com.br",
     subject: "Login e Senha"
  end
end
