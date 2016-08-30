module MailingsHelper

  #----------------------------------------------------------------------------
  def section_mailing(related, assets)
    asset = assets.to_s.singularize
    create_id  = :"create_#{asset}"
    select_id  = :"select_#{asset}"
    create_url = controller.send(:"new_#{asset}_path")
    
    
    select_mailinglist = render "add_list"


    html = "<br />".html_safe
    html << content_tag(:div, "", :class => "subtitle_tools")
    html << content_tag(:div, link_to(t(select_id), "#", :id => select_id), :class => "subtitle_tools")
    html << content_tag(:div, "&nbsp;|&nbsp;".html_safe, :class => "subtitle_tools")
    #html << content_tag(:div, "", :class => "subtitle_tools", :id => :create_contact)
    html << content_tag(:div, link_to_inline(create_id, create_url, :related => dom_id(related), :text => t(create_id)), :class => "subtitle_tools")
    html << content_tag(:div, select_mailinglist, :class => "subtitle_tools")
    html << content_tag(:div, 'Bestemmelingen'  , :class => :subtitle, :id => :"create_#{asset}_title")
    html << content_tag(:div, "", :class => :remote, :id => create_id, :style => "display:none;")
  end

  def periodically_call_remote(options = {})
    variable = options[:variable] ||= 'poller'
    frequency = options[:frequency] ||= 10
    code = "#{variable} = new PeriodicalExecuter(function() 
{#{remote_function(options)}}, #{frequency})"
    javascript_tag(code)
  end


end
