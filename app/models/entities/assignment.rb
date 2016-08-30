class Assignment < ActiveRecord::Base
  belongs_to :trainer, :class_name => "Contact"
  belongs_to :training
  validates_presence_of :trainer_id, :training_id

  # is_paranoid
end

