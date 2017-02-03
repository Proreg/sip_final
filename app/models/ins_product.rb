class InsProduct < ActiveRecord::Base
  belongs_to :ins_spending_type
  belongs_to :ins_insurance_company
  belongs_to :ins_inspector_product
  
  validates :description, :unit, :ind_active, presence: true
end
