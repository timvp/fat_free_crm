class TrainingDate < ActiveRecord::Base

  #include ActiveModel::Dirty
  #define_attribute_methods :remark
  
  

  belongs_to :training
  has_paper_trail
  has_fields
  sortable :by => [ "startdate ASC"], :default => "startdate ASC"
  
  scope :by_training, lambda { |training_id| where("training_id = ?",training_id)}
  scope :coming, lambda { where("startdate > ?", Time.zone.now ).order("startdate") }
  #scope :ended, lambda { where("startdate < ? and status != 'cancelled'", Time.zone.now ).order("startdate") }  
  scope :ended, lambda { where("startdate < ?", Time.zone.now ).order("startdate desc") }  
  scope :last_created, lambda { |last_date| where("created_at > ?",last_date)}
  
  validates :starttime, :format => { :with => /([0]?[1-9]|[1][0-2]|[2][0-4]):[0-5][0-9]/, :message => "Ongeldig formaat" }
  validates :duration, :format => { :with => /([0]?[1-9]|[1][0-2]|[2][0-4]):[0-5][0-9]/, :message => "Ongeldig formaat" }
  
  
  
  # def remark
#     @remark
#   end
# 
#   def remark=(val)
#     remark_will_change! unless val == @remark
#     @remark = val
#   end
# 
#   def save
#     @previously_changed = changes
#     @changed_attributes.clear
#   end
  
    #----------------------------------------------------------------------------
  def confirm
    update_attribute(:status, "confirmed")
  end

  #----------------------------------------------------------------------------
  def cancel
    update_attribute(:status, "cancelled")
  end
end
