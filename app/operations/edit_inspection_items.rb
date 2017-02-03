class EditInspectionItems
  def update(current_items, update_items) # Get the hash from the controller, and update the database
    current_items.each do |item| # get the hash from the checkboxes inside the view
      
      update_items.each do |update_item|
        return -1 if item.ins_product.ins_spending_type_id == InsProduct.find(update_item.second['ins_product']).ins_spending_type_id
      end
      
      item.update(unitary_value: update_items[item.id.to_s]['unitary_value'], 
        total_value: update_items[item.id.to_s]['total_value'],
        deductible: update_items[item.id.to_s]['deductible'],
        amount: update_items[item.id.to_s]['amount'] ,
        ins_classification_id: update_items[item.id.to_s]['ins_classification'],
        ins_product_id: update_items[item.id.to_s]['ins_product'] )
    end
  end  
 
  
  def create(new_items, inspection)
    items_inspection = InsInspectionItem.where(ins_inspection_id: inspection)
    
    new_items.each do |item|
        
      items_inspection.each do |item_inspection| # Verify if the spending type in the inspection is unique
        return -1 if item_inspection.ins_product.ins_spending_type_id == InsProduct.find(item['ins_product']).ins_spending_type_id
      end 
  
      InsInspectionItem.create(unitary_value: item['unitary_value'], 
        total_value: item['total_value'],
        deductible: item['deductible'],
        amount: item['amount'] ,
        ins_classification_id: item['ins_classification'],
        ins_product_id: item['ins_product'],
        ins_inspection_id: inspection)
    end
  end
end