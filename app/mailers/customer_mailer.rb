class CustomerMailer < ActionMailer::Base

  default :from => "info@talenhuis.be"
  
  def notify_feedback_trainer_email(training, contact, comment)
  
    
    # if attachment
#       attachments[attachment] = File.read("#{Rails.root}/public/uploads/#{attachment}")
#     end

    @comment = comment
    @contact = contact

    full_name = "Tim" ;
    email = "info@effict.be";
    subject = "test " + contact.email ;
    sent_to = "tim@effict.be" ;
    cc = "admin@effict.be"
    
    
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

 def notify_session_added_email(training_date, contact)
  
    
    # if attachment
#       attachments[attachment] = File.read("#{Rails.root}/public/uploads/#{attachment}")
#     end

    @training_date = training_date
    @contact = contact

    full_name = "Het Talenhuis" ;
    email = "info@talenhuis.be";
    subject = "HT Training - nieuwe sessie";
    sent_to = contact.email ;
    cc = "admin@effict.be"     
    
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
  
   def notify_session_changed_email(training_date, contact)
  
    
    # if attachment
#       attachments[attachment] = File.read("#{Rails.root}/public/uploads/#{attachment}")
#     end

    @training_date = training_date
    @contact = contact

    full_name = "Het Talenhuis" ;
    email = "info@talenhuis.be";
    subject = "HT Training - sessie gewijzigd" ;
    sent_to = contact.email ;
    cc = "admin@effict.be"
    
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



end
