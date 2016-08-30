class Training < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to :account
  has_many :training_targets,  -> { order 'title ASC' }, dependent: :destroy
  has_many :training_dates, -> { order 'startdate ASC' }, dependent: :destroy
  has_many :evaluations, -> { order 'created_at ASC' }, dependent: :destroy
  has_many :registrations, :dependent => :destroy
  has_many :contacts, -> { order('contacts.first_name ASC').distinct },  through:  :registrations
  has_many :assignments, :dependent => :destroy
  has_many :trainers, -> { distinct }, :through => :assignments
  #has_many :activities, :as => :subject, :order => 'created_at DESC'
  has_many :emails, :as => :mediator
  has_many :documents, :as => :entity
  
  serialize :subscribed_users, Set
  
  uses_user_permissions
  acts_as_commentable
  acts_as_taggable_on :tags
  has_paper_trail :ignore => [ :subscribed_users ]
  exportable
  sortable :by => [ "name ASC",  "startdate DESC", "cf_datum_volgende_actie DESC"], :default => "startdate DESC"
  
  validates_presence_of :name, :message => :missing_training_name
  
  
  
  scope :text_search, lambda { |query| 
    query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
    where('upper(name) LIKE upper(?)', "%#{query}%")
  }
  
  scope :ongoing, lambda { where("enddate is NULL or enddate > ?", Time.zone.now ) }
  scope :ended, lambda { where("enddate < ?", Time.zone.now ) }
  
  has_fields
  
  
  # Default values provided through class methods.
  #----------------------------------------------------------------------------
  def self.per_page ; 20     ; end
  def self.outline  ; "long" ; end

  # Backend handler for [Create New Training] form (see training/create).
  #----------------------------------------------------------------------------
#   def save_with_account_and_permissions(params)
#     account = Account.create_or_select_for(self, params[:account], params[:users])
#     self.account = account
#     self.save_with_permissions(params[:users])
#   end
  
  def save_with_account_and_permissions(params)
    save_account(params)
    result = save
    #opportunities << Opportunity.find(params[:opportunity]) unless params[:opportunity].blank?
    result
  end
  
  def update_with_account_and_permissions(params)
    save_account(params)
    # Must set access before user_ids, because user_ids= method depends on access value.
    self.access = params[:training][:access] if params[:training][:access]
    self.attributes = params[:training]
    save
  end

  # Backend handler for [Update Training] form (see training/update).
  #----------------------------------------------------------------------------
  def update1_with_account_and_permissions(params)
    if params[:account][:id] == "" || params[:account][:name] == ""
      self.account = nil # Training is not associated with the account anymore.
    else
      account = Account.create_or_select_for(self, params[:account], params[:users])
      if self.account != account and account.id.present?
        self.account = account
      end
    end
    self.reload
    params[:training][:account_id] = account.id
    self.update_with_permissions(params[:training], params[:users])
  end

  
  # Attach given attachment if it hasn't been attached already.
  #---------------------------------------------------------------------------
  def attach!(attachment)
    unless send("#{attachment.class.name.downcase}_ids").include?(attachment.id)
      send(attachment.class.name.tableize) << attachment
    end
  end
  
  # Discard given attachment
  #----------------------------------------------------------------------------
  def discard!(attachment)
    if attachment.is_a?(Task)
      attachment.update_attribute(:asset, nil)
    else # Contacts
      self.send(attachment.class.name.tableize).delete(attachment)
    end
  end
  
  def attach_trainer!(attachment)
    unless self.send("trainer_ids").include?(attachment.id)
      self.send("trainers") << attachment
    end
    #unless self.send("trainer_ids").include?(attachment.id)
      #attachment.trainer_id = attachment.contact_id	
    	#assignment = Assignment.new
    	#assignment.trainer = attachment
    	#assignment.training = self
    	#assignment.save!
    #end
  end
  
  def discard_trainer!(attachment)
    self.send("trainers").delete(attachment)
  end
  
  def save_account(params)
    account_params = params[:account]
    if account_params[:id] == "" || account_params[:name] == ""
      self.account = nil
    else
      self.account = Account.create_or_select_for(self, account_params)
    end
  end
  
end
