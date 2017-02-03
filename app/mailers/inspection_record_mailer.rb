class InspectionRecordMailer < ApplicationMailer
  def inspector_chosen(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def inspector_canceled(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end 
  
  def inspector_scheduling(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def inspector_scheduling_problem(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def reject_inspection(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def run_inspection(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def inspection_run_problem(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def inspection_frustated(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def send_report(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
  end
  
  def cancel(inspection, inspector_record_type)
    @inspection = InsInspection.find(inspection)
    @inspection_record_type = inspector_record_type
    mail(to: EmailsFromRecordType.new(@inspection.id, @inspection_record_type.id).get,
    subject: inspector_record_type.subject)
     
  end
end