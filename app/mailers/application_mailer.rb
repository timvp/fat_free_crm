 class ApplicationMailer < ActionMailer::Base
  
  default :from => "info@talenhuis.be"
  
  def online_email(email,attachment)
  
    @email = email
    
    if attachment
      attachments[attachment] = File.read("#{Rails.root}/public/uploads/#{attachment}")
    end
    
    logger.info( "!!!!!MAIL " + email.user.email + " - " + email.sent_to + " - " + email.subject)
    
    mail(:from => "#{email.user.full_name} <#{email.user.email}>",
         :reply_to => "#{email.user.email}", 
         :cc => "#{email.cc}",
         :bcc => "#{email.bcc}",
         :to => "#{email.sent_to}", 
         :subject => "#{email.subject}")

#     mail(:from => email.user.email,
#          :reply_to => email.user.email, 
#          :cc => email.cc,
#          :to => email.sent_to, 
#          :subject => email.subject)


  end
  
  def test_mail(id, to_address)
  
  	@mailing = Mailing.find(id)
 
  	mail(:from => "info@talenhuis.be",
         :reply_to => "info@talenhuis.be", 
         :to => to_address, 
         :subject => @mailing.subject)
  end
  
  def deliver_mailing(mailing, destinee)
  
    @mailing = mailing
    
  	mail(:from => "info@talenhuis.be",
         :reply_to => "info@talenhuis.be", 
         :to => destinee.contact.email, 
         :subject => @mailing.subject)
  end
  
end