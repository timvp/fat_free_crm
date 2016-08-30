class MailingsController < EntitiesController

  before_filter :get_users, :only => [ :new, :create, :edit, :update ]
  #before_filter :get_accounts, :only => [ :new, :create, :edit, :update ]
   
  # GET /mailings
  def index
    @mailings = get_mailings(:page => params[:page])
    respond_with(@mailings)
  end
  
  # GET /mailings/1
  #----------------------------------------------------------------------------

  def show
    @mailinglists = Mailinglist.my.all
    @lists = List.where("url like '/contacts?%'")
    #@responsible = @mailing.account.contacts.where(:cf_opleidingsverantwoordelijke => true).first unless !@mailing.account
    respond_with(@mailing) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@mailing)
      end
    end
  end

  # GET /mailings/new
  #----------------------------------------------------------------------------
  def new
    @mailing.attributes = {:user => current_user, :access => Setting.default_access}
    @account = Account.new(:user => current_user)

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) and return
      end
    end

    respond_with(@mailing)
  end

  
  # POST /mailings
  #----------------------------------------------------------------------------
  def create
    @users = User.except(@current_user)
    
    if @mailing.save_with_permissions(params[:users])
      if called_from_index_page?
        respond_with(@mailing) do |format|
          @mailings = get_mailings
          get_data_for_sidebar
        end
      else
        render :js => "window.location = '/mailings/#{@mailing.id}'"
      end
    else
      respond_with(@mailing)
    end
    # respond_with(@mailing) do |format|
#       if @mailing.save_with_permissions(params[:users])
#         if called_from_index_page?
#           @mailings = get_mailings
#           get_data_for_sidebar
#         else
#           redirect_to(@mailing)
#         end
#       end
#     end
  end
  
  # GET /mailings/1/edit
  #----------------------------------------------------------------------------
  def edit
    @users = User.except(@current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Mailing.my.find_by_id($1) || $1.to_i
    end

    respond_with(@mailing)
  end
  
# GET /mailings/1/duplicate
  #----------------------------------------------------------------------------
  def duplicate
    @users = User.except(@current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Mailing.my.find_by_id($1) || $1.to_i
    end
    
    @previous = Mailing.my.find_by_id(params[:id])
    
    @mailing = Mailing.new
    @mailing.attributes = {:user => current_user, :access => Setting.default_access}
    
    @mailing.subject = @previous.subject
    @mailing.text = @previous.text
    @mailing.html = @previous.html
    @mailing.status = :draft

    
      render :new
   
  end
  
  
  # PUT /mailings/1
  #----------------------------------------------------------------------------  
  def update
    respond_with(@mailing) do |format|
      if @mailing.update_with_permissions(params[:mailing], params[:users])
        get_data_for_sidebar
      else
        @users = User.except(@current_user) # Need it to redraw [Edit Mailing] form.
      end
    end
  end
  
  # GET /contacts/options                                                  AJAX
  #----------------------------------------------------------------------------
  def options
    unless params[:cancel].true?
      @per_page = current_user.pref[:mailings_per_page] || Mailing.per_page
      @outline  = current_user.pref[:mailings_outline]  || Mailing.outline
      @sort_by  = current_user.pref[:mailings_sort_by]  || Mailing.sort_by
    end
  end
  
  # POST /trainings/redraw                                                 AJAX
  #----------------------------------------------------------------------------
  def redraw
    @current_user.pref[:mailings_per_page] = params[:per_page] if params[:per_page]
    @current_user.pref[:mailings_outline]  = params[:outline]  if params[:outline]
    @current_user.pref[:mailings_sort_by]  = Mailing::sort_by_map[params[:sort_by]] if params[:sort_by]
    @mailings = get_mailings(:page => 1)
    render :index
  end
  
  # DELETE /mailings/1
  #----------------------------------------------------------------------------
  def destroy
    @mailing.destroy

    respond_with(@contact) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end
  
  def show_preview
  	@mailing = Mailing.find(params[:id])
  	
  	render :layout => false
  end
  
  def attach
    model = Mailing.find(params[:id])
    @attachment = params[:assets].classify.constantize.find(params[:asset_id])
    @attached = model.attach!(@attachment)
    @mailing = model.reload
    
    @mailing_destinees = @mailing.mailing_destinees

    respond_to do |format|
      format.js  { render "mailings/add_list" }
      format.xml { render :xml => model.reload.to_xml }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :xml)
  end
  
  # Common discard handler for all core controllers.
  #----------------------------------------------------------------------------
  def discard
    model = Mailing.find(params[:id])
    @attachment = params[:attachment].constantize.find(params[:attachment_id])
    model.discard!(@attachment)
    @account  = model.reload if model.is_a?(Account)
    @campaign = model.reload if model.is_a?(Campaign)

    respond_to do |format|
      format.js  { render "entities/discard" }
      format.xml { render :xml => model.reload.to_xml }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :xml)
  end

  
  def add_list
  
    if params[:list_url]
      require 'rack'
      uri = params[:list_url]
      env = Rack::MockRequest.env_for(uri)
      req = Rack::Request.new(env) 
      search = Contact.search(req.params["q"])
      search.build_grouping unless search.groupings.any?
      @contacts = search.result
    else
    	mailinglist = Mailinglist.find(params[:mailinglist_id])
    	@contacts = mailinglist.contacts
    end
    
    mailing = Mailing.find(params[:id])	
    contact_ids = mailing.contacts.map(&:id)
    contact_emails = mailing.contacts.map(&:email)
    @contacts.each do |contact|
  		unless contact_ids.include?(contact.id)
  		  unless contact_emails.include?(contact.email)
  			  mailing.contacts << contact
  		  end
  		end 
  	end
  	@contacts = mailing.contacts
  	@mailing_destinees = mailing.mailing_destinees
  	mailing.save!
  	
  end
  
  def deliver_test
    
    mailing = Mailing.find(params[:id])
    to_address = params[:to_address]
    #mailing.status = 'In wachtrij' ;
    #mailing.save!
    
    if mailing && to_address
      ApplicationMailer.test_mail(mailing.id, to_address).deliver
      flash[:notice] = "Test mail wordt verstuurd"
    else
      flash[:error] = "Geen geldige mailing of mailadres"
    end
    
  end
  
  def deliver
  
    mailing = Mailing.find(params[:id])
    mailing.status = :in_wait ;
    mailing.save!
    
    if mailing
      to_address = params[:to_address]
      mailing.delay.deliver_mailing(mailing.id)
      totalDestinees = mailing.mailing_destinees.count
      flash[:notice] = "Mailing zal worden verstuurd naar #{totalDestinees} bestemmelingen"
      @mailing = mailing
    end
  
  end
  
  def update_status
     mailing = Mailing.find(params[:id])
     #total_sent = mailing.mailing_destinees.sent.size
     total_sent = mailing.mailing_destinees.sent.size
     total_to_sent = mailing.mailing_destinees.size
     
     
     
     if mailing.status != 'sent'
       #render :text => '<span class="strip ' + mailing.status + '">' + t(mailing.status) + "</span> - Aantal verzonden :  #{total_sent}/#{total_to_sent}"
       render :text => 'Status : ' + t(mailing.status) + " - Aantal verzonden :  #{total_sent}/#{total_to_sent}"
     else
       render :text => 'Status : ' + t(mailing.status) + " - Aantal verzonden :  #{total_sent}/#{total_to_sent}" + "<script>poller.stop();$('loading').hide();</script>"
     end
  
  end
  
  private
  
  #----------------------------------------------------------------------------
  alias :get_mailings :get_list_of_records

  #----------------------------------------------------------------------------
  def get_accounts
    @accounts = Account.my.order('name')
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      @mailings = get_mailings
      if @mailings.blank?
        @mailings = get_mailings(:page => current_page - 1) if current_page > 1
        render :index and return
      end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @mailing.subject)
      redirect_to mailings_path
    end
  end
  
  def get_data_for_sidebar
  end

   
end



