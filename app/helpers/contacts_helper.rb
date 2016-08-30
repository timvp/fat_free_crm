# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module ContactsHelper
  # Contact summary for RSS/ATOM feeds.
  #----------------------------------------------------------------------------
  def contact_summary(contact)
    summary = [""]
    summary << contact.title.titleize if contact.title?
    summary << contact.department if contact.department?
    if contact.account && contact.account.name?
      summary.last << " #{t(:at)} #{contact.account.name}"
    end
    summary << contact.email if contact.email.present?
    summary << "#{t(:phone_small)}: #{contact.phone}" if contact.phone.present?
    summary << "#{t(:mobile_small)}: #{contact.mobile}" if contact.mobile.present?
    summary.join(', ')
  end
  
   def contact_type_state_checbox(type_state, count)
    entity_filter_checkbox(:state, type_state, count)
  end
  
    def ccontact_type_state_checbox(type_state, count)
    checked = (session[:filter_by_contact_type_state] ? session[:filter_by_contact_type_state].split(",").include?(type_state.to_s) : count.to_i > 0)
    onclick = remote_function(
      :url      => { :action => :filter },
      :with     => h(%Q/"type_state=" + $$("input[name='type_state[]']").findAll(function (el) { return el.checked }).pluck("value")/),
      :loading  => "$('loading').show()",
      :complete => "$('loading').hide()"
    )
    check_box_tag("type_state[]", type_state, checked, :id => type_state, :onclick => onclick)
  end

end
