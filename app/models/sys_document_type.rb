class SysDocumentType < ActiveRecord::Base
  has_many :ins_inspector_files
  has_many :ins_sub_inspector_files

  validates :description, presence: true, uniqueness: true
end
