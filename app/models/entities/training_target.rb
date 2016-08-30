class TrainingTarget < ActiveRecord::Base
  belongs_to :training
  has_paper_trail
  has_fields
  sortable :by => [ "title ASC"], :default => "title ASC"
end
