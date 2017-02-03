class UnmaskMoney
  def initialize(value)
    @value = value
  end
  
  def format
    @value = @value.tr('R$', '').tr('.', '').tr(',','').to_i
  end
end