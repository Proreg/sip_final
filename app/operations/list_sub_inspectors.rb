class ListSubInspectors
  def perform(inspector)
    # Gets a list of sub_inspectors' ids for a specific inspector
    list = InsInspXSubInspector.where(ins_inspector_id: inspector)
    sub_inspectors = Array.new
    list.each do |sub|
      sub_inspectors.push(sub.ins_sub_inspector_id)
    end
    return sub_inspectors
  end
end