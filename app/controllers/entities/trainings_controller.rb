class TrainingsController < EntitiesController

  before_filter :get_users, :only => [ :new, :create, :edit, :update ]
  before_filter :get_accounts, :only => [ :new, :create, :edit, :update ]
  #respond_to :html, :json, :js, :pdf
   
  # GET /trainings
  def index
    @trainings = get_trainings(:page => params[:page])
    respond_with(@trainings)
  end
  
  # GET /trainings/1
  #----------------------------------------------------------------------------

  def show
  
    @responsible = @training.account.contacts.where(:cf_opleidingsverantwoordelijke => true).first unless !@training.account
    respond_with(@training) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@training)
      end
    end
  end
  
  # GET /trainings/new
  #----------------------------------------------------------------------------
  def new
    @training.attributes = {:user => current_user, :access => Setting.default_access}
    @account = Account.new(:user => current_user)

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) and return
      end
    end

    respond_with(@training)
  end

  
  # POST /trainings
  #----------------------------------------------------------------------------
  def create
    respond_with(@training) do |format|
      if @training.save_with_account_and_permissions(params)
        @trainings = get_trainings if called_from_index_page?
      else
        unless params[:account][:id].blank?
          @account = Account.find(params[:account][:id])
        else
          if request.referer =~ /\/accounts\/(.+)$/
            @account = Account.find($1) # related account
          else
            @account = Account.new(:user => current_user)
          end
        end
      end
    end
  end
  
  # GET /trainings/1/edit
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Contact.my.find_by_id($1) || $1.to_i
    end
    @account  = @training.account || Account.new(:user => @current_user)
  end
  
  def update
    respond_with(@training) do |format|
      unless @training.update_with_account_and_permissions(params.permit!)
        #@users = User.except(current_user)
        @account  = @training.account || Account.new(:user => @current_user)
      end
    end
  end
  
  # DELETE /trainings/1
  #----------------------------------------------------------------------------
  def destroy
    @training.destroy

    respond_with(@training) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end
  
  # GET /trainings/options                                                  AJAX
  #----------------------------------------------------------------------------
  def options
    unless params[:cancel].true?
      @per_page = @current_user.pref[:trainings_per_page] || Training.per_page
      @outline  = @current_user.pref[:trainings_outline]  || Training.outline
      @sort_by  = @current_user.pref[:trainings_sort_by]  || Training.sort_by
    end
  end
  
  # Common attach handler for all core controllers. 
  #----------------------------------------------------------------------------
  # hier overridden maar zit eigenlijk standaard in EntitiesController
  def attach
  
    entity = Training.my.find(params[:id])
    
    logger.info('ik ben hier')
    
    if params[:assets] == 'trainers'
    	@attachment = Contact.find(params[:asset_id])
    	@attached = entity.attach_trainer!(@attachment)
    	#params[:assets] = 'contacts'
    else 
      @attachment = params[:assets].classify.constantize.find(params[:asset_id])
      @attached = entity.attach!(@attachment)
    end 

    entity.reload

    #respond_with(entity)
  end

  # Common discard handler for all core controllers.
  #----------------------------------------------------------------------------
  def discard
    
    entity = Training.my.find(params[:id])
    
    if params[:attachment] == 'Trainer' 
      @attachment = Contact.find(params[:attachment_id])
      entity.discard_trainer!(@attachment)
    else
	    @attachment = params[:attachment].constantize.find(params[:attachment_id])
  	  entity.discard!(@attachment)
    end
    
    entity.reload
    #respond_with(entity)
  end
  
  # POST /trainings/redraw                                                 AJAX
  #----------------------------------------------------------------------------
  def redraw
    @current_user.pref[:trainings_per_page] = params[:per_page] if params[:per_page]
    @current_user.pref[:trainings_outline]  = params[:outline]  if params[:outline]
    @current_user.pref[:trainings_sort_by]  = Training::sort_by_map[params[:sort_by]] if params[:sort_by]
    @trainings = get_trainings(:page => 1)
    render :index
  end
  
  def screening_report
    respond_to do |format|
      format.pdf do
        render :pdf => "screening_report",
               :template => "trainings/screening_report.pdf.erb",
               #:layout => 'pdf',
               :footer => {
                 :left => "HT - Het Talenhuis",
                 :right => "Screening"
               },
               :show_as_html => params[:debug]
      end
    end
  end
  
  private
  
  #----------------------------------------------------------------------------
  alias :get_trainings :get_list_of_records

  #----------------------------------------------------------------------------
  def get_accounts
    @accounts = Account.my.order('name')
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      @trainings = get_trainings
      if @trainings.blank?
        @trainings = get_trainings(:page => current_page - 1) if current_page > 1
        render :index and return
      end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @training.name)
      redirect_to trainings_path
    end
  end
  
  def get_data_for_sidebar
  end

   
end



