module TrainingsHelper

  def link_to_discard_trainer(model)
    name = model.class.name.downcase
    current_url = (request.xhr? ? request.referer : request.fullpath)
    parent, parent_id = current_url.scan(%r|/(\w+)/(\d+)|).flatten

    link_to(t(:discard),
      url_for(:controller => parent, :action => :discard, :id => parent_id, :attachment => 'Trainer', :attachment_id => model.id),
      :method  => :post,
      :remote  => true,
      :onclick => visual_effect(:highlight, dom_id(model), :startcolor => "#ffe4e1")
    )
  end
end
