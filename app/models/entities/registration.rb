class Registration < ActiveRecord::Base
  belongs_to :contact
  belongs_to :training
  validates_presence_of :contact_id, :training_id

  has_paper_trail
end
