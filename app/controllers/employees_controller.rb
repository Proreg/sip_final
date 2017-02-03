class EmployeesController < ApplicationController
  before_action :set_employee, except: [:list, :new, :update, :create, :destroy] #Call the method set_employee before every action, but the list method
  
  def list
    @employees = Employee.all
  end
  
  def show  
  end
  
  def edit
    @sectors = Sector.all
  end

  def new  
    @employee = Employee.new
    @sectors = Sector.all 
  end
  
  def destroy
    Employee.find(params[:id]).destroy
    redirect_to :action=>'list'
  end
  
  def create
    @employee= Employee.new(valid_params)
    
    if @employee.save
      redirect_to :action=>'show', :id=>@employee
    else
      redirect_to :action => 'list'
    end
    
  end
   
  def update
      @employee = Employee.find(params[:id])
      if @employee.update_attributes(valid_params)  
         redirect_to :action => 'show', :id => @employee
      else
         render :action => 'list'
      end    
  end
  
  private #Setters and getters
  
  def valid_params
    params.require(:employee).permit(:name, :extension_line, :cpf, :rg, :date_of_birth, :hiring_date, :active, :date_inactive, :sector_id)#params require é usado para updates de varios valores. Nesse exemplo apenas um foi alterado
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
