class TrainingDatesController < EntitiesController

  # GET /contacts/new
  #----------------------------------------------------------------------------
  def new
    @training_date  = TrainingDate.new

    if params[:related]
      model, id = params[:related].split("_")
      instance_variable_set("@#{model}", model.classify.constantize.my.find(id))
    end

    respond_with(@training_date)

  rescue ActiveRecord::RecordNotFound # Kicks in if related asset was not found.
    respond_to_related_not_found(model, :js) if model
  end
  
  # POST /training_dates
  #----------------------------------------------------------------------------
  def create
    @training_date = TrainingDate.new(params[:training_date])

    respond_with(@training_date) do |format|
      if @training_date.save
        #update_sidebar if called_from_index_page?
        #@training_dates = get_training_dates if called_from_index_page?
      end
    end  
  end
  
  # GET /training_dates/1/edit
  #----------------------------------------------------------------------------
  def edit
    @training_date = TrainingDate.find(params[:id])
  end
  
  # PUT /training_dates/1
  #----------------------------------------------------------------------------
  def update
    @training_date = TrainingDate.find(params[:id])

    respond_with(@training_date) do |format|
      if @training_date.update_attributes(params[:training_date].permit!)
			#	get_data_for_sidebar if called_from_index_page?
      #else
      #  @users = User.except(@current_user) # Need it to redraw [Edit TrainingDate] form.
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :json, :xml)
  end
  
  # DELETE /training_dates/1
  #----------------------------------------------------------------------------
  def destroy
    @training_date = TrainingDate.find(params[:id])
    @training_date.destroy if @training_date

    respond_with(@training_date) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
 

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :json, :xml)
  end
  
  # PUT /training_dates/1/cancel
  #----------------------------------------------------------------------------
  def cancel
    @training_date.cancel
    #update_sidebar
  end
  
  # PUT /training_dates/1/confirm
  #----------------------------------------------------------------------------
  def confirm
    @training_date.confirm
    #update_sidebar
  end
  
  
  private
  #----------------------------------------------------------------------------
  def get_training_dates(options = {})
    get_list_of_records(TrainingDate, options)
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      #@training_dates = get_training_dates
      #if @training_dates.blank?
      #  @training_dates = get_training_dates(:page => current_page - 1) if current_page > 1
        #render :index and return
      #end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @training_date.name)
      redirect_to training_dates_path
    end
  end
  
  def get_data_for_sidebar
  end
   
end

