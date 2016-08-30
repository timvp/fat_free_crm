class Evaluation < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  belongs_to  :training
  has_many :activities, -> { order('created_at DESC')}, :as => :subject
  has_many :emails, :as => :mediator
  
  uses_user_permissions
  acts_as_commentable
  has_paper_trail :ignore => [ :subscribed_users ]
  exportable
  sortable :by => [ "name ASC"], :default => "name ASC"
  
  validates_presence_of :name, :message => :missing_name
  validates_presence_of :cf_type, :message => :missing_type
  
  serialize :subscribed_users, Set
  
  scope :begin, -> { where(:cf_type => 'Begin') }
  scope :tussentijds, -> { where(:cf_type => 'Tussentijds') }
  scope :eind, -> { where(:cf_type => 'Eind') }
  scope :eind_trainer, -> { where(:cf_type => 'EindTrainer') }
  
  scope :text_search, lambda { |query|
    query = query.gsub(/[^@\w\s\-\.'\p{L}]/u, '').strip
    where("upper(name) LIKE upper(:m)", :m => "%#{query}%")
  }
  
  has_fields
  
  # Attach given attachment if it hasn't been attached already.
  #----------------------------------------------------------------------------
  def attach!(attachment)
    unless self.send("#{attachment.class.name.downcase}_ids").include?(attachment.id)
      self.send(attachment.class.name.tableize) << attachment
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
  
    # Make sure at least one user has been selected if the campaign is being shared.
  #----------------------------------------------------------------------------
  def users_for_shared_access
    errors.add(:access, :share_evaluation) if self[:access] == "Shared" && !self.permissions.any?
  end
  
end
