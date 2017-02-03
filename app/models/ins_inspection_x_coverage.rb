class InsInspectionXCoverage < ActiveRecord::Base
  belongs_to :ins_inspection
  belongs_to :ins_coverage_type
end
