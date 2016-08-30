class Mailing < ActiveRecord::Base

  after_initialize :default_values
  #alias_attribute :name, :subject
 
  belongs_to :user
  has_many :mailing_destinees, :dependent => :destroy
  has_many :contacts, :through => :mailing_destinees
  has_many :emails, :as => :mediator
 
  uses_user_permissions
  acts_as_commentable
  has_paper_trail :ignore => [ :subscribed_users ]
  has_fields
  exportable

  sortable :by => [ "created_at DESC", "date_sent DESC", "subject ASC"], :default => "created_at DESC"
 
  validates_presence_of :subject, :message => :missing_name
  
  # Default values provided through class methods.
  #----------------------------------------------------------------------------
  def self.per_page ; 20     ; end
  def self.outline  ; "long" ; end
 
 
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
  
  def deliver_mailing(id)
  
    self.status = :processing
    self.save!
  
  	self.mailing_destinees.each do |destinee|
  	  begin
  	    ApplicationMailer.deliver_mailing(self, destinee).deliver
  	    destinee.update_attributes(:status => 'sent', :sent_at => Time.now)
  	  rescue Exception
     	  destinee.update_attributes(:status => 'error')
  	  end
  	end
  	
  	self.status = :sent
  	self.date_sent = Time.now
  	self.save!
  
  end

 
 #is_paranoid
  private
    def default_values
      self.status ||= :draft
    end

end

