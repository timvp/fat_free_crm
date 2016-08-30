class TrainingTargetsController < EntitiesController

  # GET /contacts/new
  #----------------------------------------------------------------------------
  def new
    @training_target  = TrainingTarget.new

    if params[:related]
      model, id = params[:related].split("_")
      instance_variable_set("@#{model}", model.classify.constantize.my.find(id))
    end

    respond_with(@training_target)

  rescue ActiveRecord::RecordNotFound # Kicks in if related asset was not found.
    respond_to_related_not_found(model, :js) if model
  end
  
  # POST /training_targets
  #----------------------------------------------------------------------------
  def create
    @training_target = TrainingTarget.new(params[:training_target])

    respond_with(@training_target) do |format|
      if @training_target.save
        #update_sidebar if called_from_index_page?
        #@training_targets = get_training_targets if called_from_index_page?
      end
    end  
  end
  
  # GET /training_targets/1/edit
  #----------------------------------------------------------------------------
  def edit
    @training_target = TrainingTarget.find(params[:id])
  end
  
  # PUT /training_targets/1
  #----------------------------------------------------------------------------
  def update
    @training_target = TrainingTarget.find(params[:id])

    respond_with(@training_target) do |format|
      if @training_target.update_attributes(params[:training_target].permit!)
			#	get_data_for_sidebar if called_from_index_page?
      #else
      #  @users = User.except(@current_user) # Need it to redraw [Edit TrainingTarget] form.
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :json, :xml)
  end
  
  # DELETE /training_targets/1
  #----------------------------------------------------------------------------
  def destroy
    @training_target = TrainingTarget.find(params[:id])
    @training_target.destroy if @training_target

    respond_with(@training_target) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
 

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :json, :xml)
  end
  
  private
  #----------------------------------------------------------------------------
  def get_training_targets(options = {})
    get_list_of_records(TrainingTarget, options)
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      #@training_targets = get_training_targets
      #if @training_targets.blank?
      #  @training_targets = get_training_targets(:page => current_page - 1) if current_page > 1
        #render :index and return
      #end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @training_target.name)
      redirect_to training_targets_path
    end
  end
  
  def get_data_for_sidebar
  end
   
end

