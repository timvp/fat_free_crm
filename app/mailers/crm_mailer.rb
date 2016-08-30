class CrmMailer < ActionMailer::Base

  default :from => "info@talenhuis.be"
  
  def notify_feedback_trainer_email(training, trainer, comment)
  
    
    # if attachment
    #       attachments[attachment] = File.read("#{Rails.root}/public/uploads/#{attachment}")
    # end

    @comment = comment
    @training = training


    full_name = trainer.name
    email = trainer.email
    subject = "Commentaar via Trainersportaal"
    sent_to = "portaal@talenhuis.be" 
    cc = ""
    
    
    mail(:from => "#{full_name} <#{email}>",
         :reply_to => "#{email}", 
         :cc => "#{cc}",
         :to => "#{sent_to}", 
         :subject => "#{subject}")

#     mail(:from => email.user.email,
#          :reply_to => email.user.email, 
#          :cc => email.cc,
#          :to => email.sent_to, 
#          :subject => email.subject)


  end
  
  
  def notify_session_changed_email(training_date, trainer)
  
  @training_date = training_date
  
    full_name = trainer.name
    email = trainer.email
    subject = "Training sessie gewijzigd via Trainersportaal"
    sent_to = "portaal@talenhuis.be" 
    cc = ""
  
    mail(:from => "#{full_name} <#{email}>",
         :reply_to => "#{email}", 
         :cc => "#{cc}",
         :to => "#{sent_to}", 
         :subject => "#{subject}")
  
  end

  def notify_session_added_email(training_date, trainer)
  
  
    @training_date = training_date
  
    full_name = trainer.name
    email = trainer.email
    subject = "Training sessie gewijzigd via Trainersportaal"
    sent_to = "portaal@talenhuis.be" 
    cc = ""
  
    mail(:from => "#{full_name} <#{email}>",
         :reply_to => "#{email}", 
         :cc => "#{cc}",
         :to => "#{sent_to}", 
         :subject => "#{subject}")
  
  end
  
  def notify_evaluation_added_email(evaluation, trainer)
  
    @evaluation = evaluation
    @trainer = trainer
    
    full_name = trainer.name
    email = trainer.email
    subject = "Eindevaluatie ingevuld via Trainersportaal"
    sent_to = "portaal@talenhuis.be" 
    cc = ""
  
    mail(:from => "#{full_name} <#{email}>",
         :reply_to => "#{email}", 
         :cc => "#{cc}",
         :to => "#{sent_to}", 
         :subject => "#{subject}")
  
  end
end
