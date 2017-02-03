class InspectionCoverages
  def create(coverages, inspection)    
    coverages.each do |c| 
      InsInspectionXCoverage.create(ins_coverage_type_id: c['ins_coverage_type'].to_i,
      ins_inspection_id: inspection, ins_notes: c['notes'] )
    end
  end
  
  def edit(current_coverages, update_coverages)
    current_coverages.each do |c|
      c.update(ins_coverage_type_id: update_coverages[c.id.to_s]['ins_coverage_type'].to_i,
      ins_notes: update_coverages[c.id.to_s]['ins_notes'])  
    end
  end
  
 
end