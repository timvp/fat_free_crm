class AddStatusToMailingDestinees < ActiveRecord::Migration
  def change
    add_column :mailing_destinees, :status, :text
  end
end
