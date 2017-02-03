class EditInspectorItems
  def update(current_items, update_items) # Get the hash from the controller, and update the database
    current_items.each do |item| # get the hash from the checkboxes inside the view
      item.update(
        unitary_value: UnmaskMoney.new(update_items[item.id.to_s]['unitary_value']).format,
        amount: update_items[item.id.to_s]['amount'], 
        total_value: UnmaskMoney.new(update_items[item.id.to_s]['total_value']).format
      )
    end
  end  
 
  
  def create(new_items, inspection)
    items_inspector = InsInspectorItem.where(ins_inspection_id: inspection)

    new_items.each do |item| 

      items_inspector.each do |item_inspector| # Verify if the spending type in the inspection is unique
        return -1 if item_inspector.ins_inspector_product.ins_spending_type_id == InsInspectorProduct.find(item['ins_inspector_product']).ins_spending_type_id
      end

      InsInspectorItem.create(
        unitary_value: UnmaskMoney.new(item['unitary_value']).format, 
        total_value: UnmaskMoney.new(item['total_value']).format,
        amount: item['amount'] ,
        ins_inspector_product_id: item['ins_inspector_product'],
        ins_inspection_id: inspection
      )
    end
  end
end