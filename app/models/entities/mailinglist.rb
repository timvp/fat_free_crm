class Mailinglist < ActiveRecord::Base
	
  has_and_belongs_to_many :contacts, :uniq => true, :order => 'last_name ASC'
  #has_many    :activities, :as => :subject, :order => 'created_at DESC', :dependent => :destroy
  has_many    :emails, :as => :mediator
  belongs_to  :user
    
    
  uses_user_permissions
  acts_as_commentable
  acts_as_taggable_on :tags
  has_paper_trail :ignore => [ :subscribed_users ]
  has_fields
  exportable
  sortable :by => [ "name ASC", "created_at DESC", "updated_at DESC" ], :default => "created_at DESC"
  	
  # Default values provided through class methods.
  #----------------------------------------------------------------------------
  def self.per_page ; 20                  ; end
  
  # Attach given contact to the list if it hasn't been attached already.
  #----------------------------------------------------------------------------
  def attach!(contact)
    unless self.send("#{contact.class.name.downcase}_ids").include?(contact.id)
      self.send(contact.class.name.tableize) << contact
    end
  end
  
  # Discard given contact from the list
  #----------------------------------------------------------------------------
  def discard!(contact)
    self.send(contact.class.name.tableize).delete(contact)
  end

end