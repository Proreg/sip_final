class GetCompanyHonoraria
  def initialize(company_id, inspection_value)
    @company_id = company_id
    @inspection_value = inspection_value
  end
  def format_js
    h = Hash.new{|hsh,key| hsh[key] = {} }

    honoraria = InsCompanyHonorarium.where(ins_product_id: InsProduct.where(ins_insurance_company_id: @company_id),
    ins_insurance_company_id: @company_id).where("initial_value < ?", @inspection_value).where("final_value > ?", @inspection_value)

    honoraria.each do |honorarium|
      (h.store(honorarium.ins_product_id, honorarium.honorarium_value))
    end
    return @company_honoraria = h.to_json
  end
  def format_rails
     honoraria = InsCompanyHonorarium.where(ins_product_id: InsProduct.where(ins_insurance_company_id: @company_id),
     ins_insurance_company_id: @company_id).where("initial_value < ?", @inspection_value).where("final_value > ?", @inspection_value)
  end
end
 # inspection  741596
# inspection_value = 110533
#ins_insurance_company_id = 407