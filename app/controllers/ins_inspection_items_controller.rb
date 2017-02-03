class InsInspectionItemsController < ApplicationController
  def edit 
    authorize! :edit, params[:controller]
    @items= InsInspectionItem.where(ins_inspection_id: params[:ins_inspection_id])
    @model_instance = InsInspectionItem.new
    @inspection = InsInspection.find(params[:ins_inspection_id])
  end
  
  def change
    current_items = InsInspectionItem.where(ins_inspection_id: params[:ins_inspection_id])
    items = EditInspectionItems.new
    flash[:msg_error] = 'Tipo de Despesa já existe para inspeção' if items.update(current_items, params[:items]) == -1 # Send parameters to update the DB
    if params[:new_items]
       flash[:msg_error] = 'Tipo de Despesa já existe para inspeção' if items.create(params[:new_items], params[:ins_inspection_id]) == -1
    end 

    redirect_to action: 'edit'
  end
    
  def delete
    InsInspectionItem.destroy(params[:id])
    
    redirect_to action: 'edit'
  end
end
