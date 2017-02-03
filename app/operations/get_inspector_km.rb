class GetInspectorKm
  def initialize(inspector_id)
    @inspector_id = inspector_id
  end
  
  def format
    h = Hash.new{|hsh,key| hsh[key] = {} }

    honorarium = InsInspectorHonorarium.find_by(ins_inspector_product_id: 217,
    ins_inspector_id: @inspector_id)
    
    (h.store(honorarium.ins_inspector_product_id, honorarium.honorarium_value))
    return @company_honoraria = h.to_json
  end
end