class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.references  :user                         # Who uploaded the document.
      t.references  :entity, :polymorphic => true # User, and later on Lead, Contact, or Company
      t.string      :name
      t.string      :description
      t.integer     :document_file_size              # Uploaded image file size
      t.string      :document_file_name              # Uploaded image full file name
      t.string      :document_content_type           # MIME content type
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
