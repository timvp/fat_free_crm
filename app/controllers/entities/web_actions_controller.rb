# Fat Free CRM
# Copyright (C) 2008-2011 by Michael Dvorkin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

class WebActionsController < ApplicationController

  skip_before_filter :require_user
  before_filter :validate_api
    
  def validate_api
    if params[:authkey].present? and params['authkey'] == 'aXdrGJ235160999LkJsTddddY78925a7d088yhtdk654jKlMNkkOErrrs' #ApiKey.find(params[:api_key])
      return true
    else
      head :forbidden
    end
  end

  
#   def require_application
#     params['authkey'] == 'aXdrGJ235160999LkJ'
#     @current_application_session ||= ApplicationSession.find
#     unless @current_application_session
#       redirect_to login_url
#       false
#     end
#   end
  

  # POST /leads.xml
  #----------------------------------------------------------------------------
  def create_lead
    @current_user = User.find(4)
    @lead = Lead.new(params[:lead])
    @lead.title = params[:descr]
    @lead.status = 'new' 
    @lead.assigned_to = User.find(2)
    @lead.user = @current_user 
    
    
    @lead.save
    @comment = Comment.new 
    @comment.commentable = @lead
    @comment.user = @current_user
    @comment.title = params[:comment][:title]
    @comment.comment = params[:comment][:comment]
    @comment.save 
    
    @lead.subscribed_users = []
    @lead.save
    
    @task = Task.new(:assigned_to => 2,  :name => 'Automatische lead verwerken', :bucket =>'due_asap', :category => 'follow_up') ; 
    @task.asset = @lead 
    @task.user = @current_user
    
    @task.save 

    respond_with(@lead) do |format|
      format.xml { render :xml => @lead.to_xml }
      format.json { render :json => @lead.to_json}
    end

  end


private

end
