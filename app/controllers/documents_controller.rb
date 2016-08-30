class DocumentsController < EntitiesController

  # GET /contacts/new
  #----------------------------------------------------------------------------
  def new
    @document  = Document.new

    if params[:related]
      model, id = params[:related].split("_")
      #instance_variable_set("@#{model}", model.classify.constantize.my.find(id))
      instance_variable_set("@entity", model.classify.constantize.my.find(id))
    end

    respond_with(@document)

  rescue ActiveRecord::RecordNotFound # Kicks in if related asset was not found.
    respond_to_related_not_found(model, :js) if model
  end
  
  # POST /documents
  #----------------------------------------------------------------------------
  def create
    @document = Document.new(params[:document])
    unless @document.save && @document.document.errors.blank?
      @document.document.errors.clear
      @document.document.errors.add(:document, t(:msg_bad_file))
    end
    responds_to_parent do
      render and (return if Rails.env.test?)
    end

  end


  def create2
    @document = Document.new(params[:document])
    unless @document.save && @document.document.errors.blank?
      @document.document.errors.clear
      @document.document.errors.add(:document, t(:msg_bad_file))
    end
    respond_to do |format|
      format.html { redirect_to @document, notice: 'Photo was successfully created.' }      
      format.json { 
        data = {id: @document.id} 
        render json: data, status: :created, location: @document 
      }
    end

  end
  
  # GET /documents/1/edit
  #----------------------------------------------------------------------------
  def edit
    @document = Document.find(params[:id])
  end
  
  # PUT /documents/1
  #----------------------------------------------------------------------------
  def update
    @document = Document.find(params[:id])
    
    unless @document.update_attributes(params[:document]) && @document.document.errors.blank?
      @document.document.errors.clear
      @document.document.errors.add(:document, t(:msg_bad_file))
    end
    responds_to_parent do
      render and (return if Rails.env.test?)
    end
  end
  
  # DELETE /documents/1
  #----------------------------------------------------------------------------
  def destroy
    @document = Document.find(params[:id])
    @document.destroy if @document

    respond_with(@document) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
 

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :js, :json, :xml)
  end
  
  def download
      @document = Document.find(params[:id])
      # file = File.new(@document.document.path, "r")
      # send_data(file.read,
      #  :filename     =>  @document.document_file_name,
      #  :type         =>  @document.document_content_type,
      #  :disposition  =>  'inline')  
      send_file @document.document.path, :type => @document.document_content_type, :disposition => 'inline'
  end
  
  private
  #----------------------------------------------------------------------------
  def get_documents(options = {})
    get_list_of_records(Document, options)
  end
  
  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      get_data_for_sidebar
      #@documents = get_documents
      #if @documents.blank?
      #  @documents = get_documents(:page => current_page - 1) if current_page > 1
        #render :index and return
      #end
      # At this point render destroy.js.rjs
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @document.name)
      redirect_to documents_path
    end
  end
  
  def get_data_for_sidebar
  end
   
end

