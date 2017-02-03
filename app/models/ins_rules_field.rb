class InsRulesField < ActiveRecord::Base
  validates :description, presence:true
end
