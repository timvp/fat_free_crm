class EvaluationsController < EntitiesController

  before_filter :get_users, :only => [ :new, :create, :edit, :update ]
  #before_filter :get_accounts, :only => [ :new, :create, :edit, :update ]
   
  # GET /evaluations
  def index
    @evaluations = get_evaluations(:page => params[:page])
    respond_with(@evaluations)
  end
  
  # GET /evaluations/1
  #----------------------------------------------------------------------------

  def show
  
    #@responsible = @evaluation.account.contacts.where(:cf_opleidingsverantwoordelijke => true).first unless !@evaluation.account
    respond_with(@evaluation) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@evaluation)
      end
    end
  end

  # GET /evaluations/new
  #----------------------------------------------------------------------------
  def new
    @evaluation.attributes = {:user => current_user, :access => Setting.default_access}
    @account = Account.new(:user => current_user)

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) and return
      end
    end

    respond_with(@evaluation)
  end

  
  # POST /evaluations
  #----------------------------------------------------------------------------
  def create2
    @users = User.except(@current_user)

    respond_with(@evaluation) do |format|
      if @evaluation.save_with_account_and_permissions(params)
        @evaluations = get_evaluations if called_from_index_page?
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
  
  def create
  
    @users = User.except(@current_user)
    ActionController::Base.helpers.sanitize @evaluation.cf_algemeen
    ActionController::Base.helpers.sanitize @evaluation.cf_eindevaluatie
    ActionController::Base.helpers.sanitize @evaluation.cf_motivatie
    ActionController::Base.helpers.sanitize @evaluation.cf_vorderingen
    ActionController::Base.helpers.sanitize @evaluation.cf_e_learning
    ActionController::Base.helpers.sanitize @evaluation.cf_tevredenheid_van_de_taaltrainer
    ActionController::Base.helpers.sanitize @evaluation.cf_opmerkingen
    ActionController::Base.helpers.sanitize @evaluation.cf_tips_en_advies
    ActionController::Base.helpers.sanitize @evaluation.cf_conclusie
    ActionController::Base.helpers.sanitize @evaluation.cf_behandelde_items
    ActionController::Base.helpers.sanitize @evaluation.cf_behandelde_items_grammaticaal

    respond_with(@evaluation) do |format|
      if @evaluation.save_with_permissions(params[:users])
        @evaluations = get_evaluations
        get_data_for_sidebar
      end
    end
  end
  
  # GET /evaluations/1/edit
  #----------------------------------------------------------------------------
  def edit
    @users = User.except(@current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Evaluation.my.find_by_id($1) || $1.to_i
    end

    respond_with(@evaluation)
  end
  
  
  # PUT /evaluations/1
  #----------------------------------------------------------------------------  
  def update
    ActionController::Base.helpers.sanitize @evaluation.cf_algemeen
    ActionController::Base.helpers.sanitize @evaluation.cf_eindevaluatie
    ActionController::Base.helpers.sanitize @evaluation.cf_motivatie
    ActionController::Base.helpers.sanitize @evaluation.cf_vorderingen
    ActionController::Base.helpers.sanitize @evaluation.cf_e_learning
    ActionController::Base.helpers.sanitize @evaluation.cf_tevredenheid_van_de_taaltrainer
    ActionController::Base.helpers.sanitize @evaluation.cf_opmerkingen
    ActionController::Base.helpers.sanitize @evaluation.cf_tips_en_advies
    ActionController::Base.helpers.sanitize @evaluation.cf_conclusie
    ActionController::Base.helpers.sanitize @evaluation.cf_behandelde_items
    ActionController::Base.helpers.sanitize @evaluation.cf_behandelde_items_grammaticaal
  
    respond_with(@evaluation) do |format|
      if @evaluation.update_with_permissions(params[:evaluation].permit!, params[:users])
        get_data_for_sidebar
      else
        @users = User.except(@current_user) # Need it to redraw [Edit Evaluation] form.
      end
    end
    
  end
  
  # DELETE /evaluations/1
  #----------------------------------------------------------------------------
  def destroy
    @evaluation.destroy

    respond_with(@contact) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end
  
  # Common attach handler for all core controllers. 
  #----------------------------------------------------------------------------
  # hier overridden maar zit eigenlijk standaard in EntitiesController
  def attach
  
    entity = Evaluation.my.find(params[:id])
    
    if params[:assets] == 'trainers'
    	@attachment = Contact.find(params[:asset_id])
    	@attached = entity.attach_trainer!(@attachment)
    	#params[:assets] = 'contacts'
    else 
      @attachment = params[:assets].classify.constantize.find(params[:asset_id])
      @attached = entity.attach!(@attachment)
    end 
    
    entity.reload
    respond_with(entity)
  end

  # Common discard handler for all core controllers.
  #----------------------------------------------------------------------------
  def discard
    
    entity = Evaluation.my.find(params[:id])
    
    if params[:attachment] == 'Trainer' 
      @attachment = Contact.find(params[:attachment_id])
      entity.discard_trainer!(@attachment)
    else
	    @attachment = params[:attachment].constantize.find(params[:attachment_id])
  	  entity.discard!(@attachment)
    end
    
    entity.reload
    respond_with(entity)
  end
  
  private
  
  #----------------------------------------------------------------------------
  alias :get_evaluations :get_list_of_records

  #----------------------------------------------------------------------------
  def get_accounts
    @accounts = Account.my.order('name')
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      @evaluations = get_evaluations
      if @evaluations.blank?
        @evaluations = get_evaluations(:page => current_page - 1) if current_page > 1
        render :index and return
      end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @evaluation.name)
      redirect_to evaluations_path
    end
  end
  
  def get_data_for_sidebar
  end
  
  def get_users
    @users ||= User.except(current_user)
  end

   
end



