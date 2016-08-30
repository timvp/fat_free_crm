class MailingDestinee < ActiveRecord::Base

  belongs_to :contact
  belongs_to :mailing
  
  scope :sent, -> { where("sent_at IS NOT NULL") }
  
end
