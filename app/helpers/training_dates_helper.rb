module TrainingDatesHelper
  def training_date_status_codes_for(training_date)
#     if lead.status != "converted" && (lead.new_record? || lead.contact.nil?)
#       Setting.unroll(:lead_status).delete_if { |status| status.last == :converted }
#     else
      Setting.unroll(:training_date_status)
#     end
  end
  
    #----------------------------------------------------------------------------
  def link_to_cancel_training_date(training_date)
    link_to(t(:cancel), cancel_training_date_path(training_date), :method => :put, :remote => true)
  end
  
  def link_to_confirm_training_date(training_date)
    link_to(t(:confirm), confirm_training_date_path(training_date), :method => :put, :remote => true)
  end
end 

