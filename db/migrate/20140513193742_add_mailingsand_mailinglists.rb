class AddMailingsandMailinglists < ActiveRecord::Migration
  def up
    create_table :mailinglists do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    create_table :contacts_mailinglists, :id => false do |t|
    	t.references :contact, :mailinglist
    end

    create_table :mailings do |t|
      t.string :subject
      t.text :text
      t.text :html
      t.datetime :date_sent
      t.timestamps
    end

    create_table :mail_messages do |t|
      t.string :subject
      t.string :to
      t.string :content
      t.timestamps
    end
    
    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
      table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
      table.text     :handler                      # YAML-encoded string of the object that will do work
      table.text     :last_error                   # reason for last failure (See Note below)
      table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      table.datetime :locked_at                    # Set when a client is working on this object
      table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      table.string   :locked_by                    # Who is working on this object (if locked)
      table.string   :queue                        # The name of the queue this job is in
      table.timestamps
    end

    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
    
    add_column :mailings, :status, :string
    
    create_table :mailing_destinees do |t|
			t.references :contact
			t.references :mailing
			t.datetime :sent_at
      t.timestamps
    end
  end
    
  def down
  end
end
