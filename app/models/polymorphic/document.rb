class Document < ActiveRecord::Base
  belongs_to :entity, :polymorphic => true
  has_attached_file :document,
                    :path => ":rails_root/user_files/:class/:id/:basename.:extension",
                    :url => "/documents/:id/download"
  validates_presence_of :name
  validates_presence_of :document
  	validates_attachment :document, content_type: { content_type: ["application/pdf", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "image/gif", "image/jpeg", "image/png"] }
end
