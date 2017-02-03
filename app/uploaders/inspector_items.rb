class InspectorItems
  def create(items, inspection)    
    items.each do |i| 
      InsInspectorItem.create(ins_inspection_id: inspection,
        ins_inspector_product_id: i['ins_inspector_product'].to_i,
        deductible: i["deductible"].to_i,
        amount: i["amount"],
        unitary_value: i["unitary_value"],
        total_value: i["total_value"],
        ins_notes: i["ins_notes"]
      )
    end
  end
end