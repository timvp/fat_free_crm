class MailinglistsController < EntitiesController

  #before_filter :get_users, :only => [ :new, :create, :edit, :update ]
   
  # GET /mailinglists
  def index
    @mailinglists = get_mailinglists(:page => params[:page])
    respond_with(@mailinglists)
  end
  
  # GET /mailinglists/1
  #----------------------------------------------------------------------------

  def show
    respond_with(@mailinglist) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@mailinglist)
      end
    end
  end
  
  # GET /mailinglists/new
  #----------------------------------------------------------------------------
  def new
    @mailinglist.attributes = {:user => current_user, :access => Setting.default_access}

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) and return
      end
    end
    
    respond_with(@mailinglist)
  end

  
  # POST /mailinglists
  #----------------------------------------------------------------------------
  def create
    respond_with(@mailinglist) do |format|
      if @mailinglist.save_with_permissions(params[:users])
        @mailinglists = get_mailinglists
      end
    end
  end
  
  
  # GET /mailinglists/1/edit
  #----------------------------------------------------------------------------
  def edit
    @users = User.except(@current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Mailinglist.find_by_id($1) || $1.to_i
    end

    respond_with(@mailinglist)
  end
  
  
  def update
    respond_with(@mailinglist) do |format|
      unless @mailinglist.update_with_permissions(params[:mailinglist].permit!, params[:users])        #@users = User.except(current_user)
        @users = User.except(@current_user)
      end
    end
  end
  
  # DELETE /mailinglists/1
  #----------------------------------------------------------------------------
  def destroy
    @mailinglist.destroy

    respond_with(@mailinglist) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end
  
  # GET /mailinglists/options                                                  AJAX
  #----------------------------------------------------------------------------
  def options
    unless params[:cancel].true?
      @per_page = @current_user.pref[:mailinglists_per_page] || Mailinglist.per_page
      #@outline  = @current_user.pref[:mailinglists_outline]  || Mailinglist.outline
      @sort_by  = @current_user.pref[:mailinglists_sort_by]  || Mailinglist.sort_by
    end
  end
  

  
  # POST /mailinglists/redraw                                                 AJAX
  #----------------------------------------------------------------------------
  def redraw
    @current_user.pref[:mailinglists_per_page] = params[:per_page] if params[:per_page]
    @current_user.pref[:mailinglists_outline]  = params[:outline]  if params[:outline]
    @current_user.pref[:mailinglists_sort_by]  = Mailinglist::sort_by_map[params[:sort_by]] if params[:sort_by]
    @mailinglists = get_mailinglists(:page => 1)
    render :index
  end
  

  private
  
  #----------------------------------------------------------------------------
  alias :get_mailinglists :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      @mailinglists = get_mailinglists
      if @mailinglists.blank?
        @mailinglists = get_mailinglists(:page => current_page - 1) if current_page > 1
        render :index and return
      end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @mailinglist.name)
      redirect_to mailinglists_path
    end
  end
  
  def get_data_for_sidebar
  end

   
end



