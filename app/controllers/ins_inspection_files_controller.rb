class InsInspectionFilesController < ApplicationController
  
  def index
    authorize! :show, params[:controller] 
    @inspection = InsInspection.find(params[:ins_inspection_id])
    @files = InsInspectionFile.where(ins_inspection_id: params[:ins_inspection_id])
  end
  
  def download
    file = InsInspectionFile.find(params[:ins_inspection_file_id])
    if file.inspection_path
      send_file file.inspection_path.gsub('\\10.0.0.80\e\E-MAIL', '\inspection_files').gsub('\\10.0.0.80\e\e-mail', '\inspection_files').gsub('\\server2\e\EMAIL', '\inspection_files').gsub("\\\\10.0.0.80\\c\\doc\\rodolfo 010101\\GRASI\\Relatórios", "\\system_reports").tr("\\", "//") 
    elsif file.ins_report_file_id
      send_file file.ins_report_file_id
    elsif file.inspector_upload
      send_file file.inspector_upload.file.file
    end 
    
  end
  
  def selected_files
    SetReportFiles.new.perform(params[:files], params[:ins_inspection_id]) 
    
    redirect_to action: "add"
  end
  
  def add
    authorize! :create, params[:controller] 
    inspection = InsInspection.find(params[:ins_inspection_id])
    report_files = InsReportFile.where(ins_insurance_company_id: inspection.ins_insurance_company_id) #example with bradesco
    
    @root_folder = report_files.first.report_path.split("/").third # get ins_company name  
    
    path = Hash.new{|hsh,key| hsh[key] = [] } #initialize hash
    
    accepted_formats = [".doc", ".docx", ".xlsx", ".xls", ".pdf"]
    
    report_files.each do |d|
      split_dir = d.report_path.split("/")
      split_dir = split_dir -  ["system_reports"] - [""]
      if split_dir.count == 3 && accepted_formats.include?(File.extname(split_dir.third))
        path[split_dir.second] << d
      elsif split_dir.count == 2 && accepted_formats.include?(File.extname(split_dir.second))
        path["root"] << d
      end      
    end
    @path = path
    @inspection = InsInspection.find(params[:ins_inspection_id])
  end  
end
