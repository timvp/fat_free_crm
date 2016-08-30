class EmailCompositionsController < ApplicationController

  before_filter :require_user
  
  # GET /email
  # GET /email.xml                                              not implemented
  #----------------------------------------------------------------------------
  # def index
  # end

  # GET /email/1
  # GET /email/1.xml                                            not implemented
  #----------------------------------------------------------------------------
  # def show
  # end

  # GET /emails/new
  # GET /emails/new.xml                                         not implemented
  #----------------------------------------------------------------------------
  # def new
  # end

  # GET /emails/1/edit                                          not implemented
  #----------------------------------------------------------------------------
  # def edit
  # end
  
  # POST /email_compositions
  # POST /email_compositions.xml                                                     AJAX
  #----------------------------------------------------------------------------
  def create 
    
    @emailComposition = EmailComposition.new(params[:email_composition])
    
    if @emailComposition.valid? 
      
      logger.debug "*****************************************************"
      logger.debug "Emailcomposition " + @emailComposition.inspect
      logger.debug "params " + params.inspect
      logger.debug "session " + session.inspect

      
      if params[:attachment]
         attachment_name = params[:attachment].original_filename
         directory = "public/uploads/"
         path = File.join(directory, attachment_name)
         File.open(path, "wb") { |f| f.write(params[:attachment].read) }
      end
      
      addressees = Array.new
      bcc_email = Email.new
      
      @emailComposition.contactids.each do |contactid|  
	      contact = Contact.find(contactid)
	      @contact = contact 
	      addressees << contact.email
	      logger.debug "Mail to contact " + contact.attributes.inspect
	      email = Email.new 
	      email.sent_from = @current_user.email	
		    email.mediator = contact
		    email.sent_to = contact.email
		    email.subject = @emailComposition.subject
		    email.body = @emailComposition.body
		    email.cc = @emailComposition.cc
		    email.bcc =@emailComposition.bcc
		    email.user = @current_user
		  	email.imap_message_id ='9999999'
		  	email.sent_at = Time.now
		  	email.state = 'Collapsed'
		  	ApplicationMailer.online_email(email, attachment_name).deliver
		  	#ApplicationMailer.delay.test_mail
		  	email.save! unless @emailComposition.save_as_mail == '0'
		  	bcc_email = email
      end
      
      if bcc_email.bcc.present?
        bcc_email.sent_to = bcc_email.bcc
        bcc_email.body = "Volgende mail werd verstuurd naar " + addressees.join(",") + "\n\n".html_safe + @emailComposition.body
        ApplicationMailer.online_email(bcc_email, attachment_name).deliver
      end
      
      flash[:notice] = "Mail wordt verstuurd"

      @multiple = @emailComposition.contactids.length == 1 ? false : true

    end
    
    redirect_to :back

    #respond_to do |format|
    #format.js   # create.js.rjs
    #format.html redirect_to(request.env["HTTP_REFERER"])
	#end
	
  end

  # PUT /emails/1
  # PUT /emails/1.xml                                           not implemented
  #----------------------------------------------------------------------------
  # def update
  # end
  

  # DELETE /emails/1
  # DELETE /emails/1.xml                                                   AJAX
  #----------------------------------------------------------------------------
   
end
