# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    # handle signup
    can(:create, User) if User.can_signup?

    if user.present?
      entities = [Account, Campaign, Contact, Lead, Opportunity, Training, Evaluation, Mailinglist, Mailing]
      
            if user.is_customer_responsible?
        can :read, Contact, :account => {:id => user.customer_id}
        can :read, Account, :id => user.customer_id
        can :read, Training, :account_id => user.customer_id
        can :read, Evaluation, :training => {:account_id => user.customer_id}
        can :read, TrainingTarget, :training => {:account_id => user.customer_id}
        can :read, TrainingDate, :training => {:account_id => user.customer_id}
        #can :download, Document, :entity => {  :account_id => user.customer_id } 
        can :create, Comment
        #can :manage, Document
      elsif user.is_customer?
        can :read, Contact, :account => {:id => user.customer_id}, :trainings => {:account_id => user.customer_id, :contacts => {:id => user.employee_id}}
        can :read, Account, :id => user.customer_id
        can :read, Training, :account_id => user.customer_id, :contacts => {:id => user.employee_id}
        #can :read, Evaluation, :training => {:account_id => user.customer_id}
        can :read, TrainingTarget, :training => {:account_id => user.customer_id}
        can :read, TrainingDate, :training => {:account_id => user.customer_id}
        can :download, Document, :entity => {  :account_id => user.customer_id } 
        can :create, Comment
        #can :manage, Document
      elsif user.is_trainer?
        can :create, Evaluation
#         can :read, Contact, ["(cf_opleidingsverantwoordelijke = 1 and exists (select 1 from accounts a2, trainings t2, account_contacts ac where t2.account_id = a2.id and a2.id = ac.account_id and ac.contact_id = contacts.id)) or contacts.id in (select c.id from contacts c, registrations r, trainings t where t.id = r.training_id and r.contact_id = c.id and t.assigned_to = #{user.id})"] do |contact|
#           access = true
#           if contact.cf_opleidingsverantwoordelijke && contact.account.trainings.where(:assigned_to => user.id).any?
#             access = true
#           elsif contact.trainings.where(:assigned_to => user.id).any?
#             access = true
#           else
#             access = false
#           end  
        
#         can :read, Contact, ["contacts.id in (select c.id from contacts c, registrations r, trainings t where t.id = r.training_id and r.contact_id = c.id and t.assigned_to = #{user.id})"] do |contact|
#           access = true
#           if contact.trainings.where(:assigned_to => user.id).any?
#             access = false
#           else
#             access = false
#           end  
#         end
#         can :read, Account, ["accounts.id in (select a.id from accounts a, trainings t where t.account_id = a.id and t.assigned_to = #{user.id})"] do |training|
#           access = false
#         end
        #can :read, Contact, :trainings => { :assigned_to => user.id}
        #can :read, Contact, :cf_opleidingsverantwoordelijke => true#, :account => { :trainings => {:assigned_to => user.id}  }
        can :read, Contact, :trainings => { :assigned_to => user.id}
        can :read, Account, :trainings => { :assigned_to => user.id}
        can :read, Training, :assigned_to => user.id
        can :read, Evaluation, :training => { :assigned_to => user.id}
        can :manage, Evaluation, :user_id => user.id
        can :read, TrainingTarget
        can :manage, TrainingDate
        can :manage, Document
        can :create, Comment
        # entities.each do |klass|
#           permissions = user.permissions.where(:asset_type => klass.name)
#           can :manage, klass, :id => permissions.map(&:asset_id)
#         end
      else


	      # User
	      can :manage, User, id: user.id # can do any action on themselves
	
	      # Tasks
	      can :create, Task
	      can :manage, Task, user: user.id
	      can :manage, Task, assigned_to: user.id
	      can :manage, Task, completed_by: user.id
	
	      # Entities
	      can :manage, entities, access: 'Public'
	      can :manage, entities + [Task], user_id: user.id
	      can :manage, entities + [Task], assigned_to: user.id
	
	      #
	      # Due to an obscure bug (see https://github.com/ryanb/cancan/issues/213)
	      # we must switch on user.admin? here to avoid the nil constraints which
	      # activate the issue referred to above.
	      #
	      if user.admin?
	        can :manage, :all
	      else
	        # Group or User permissions
	        t = Permission.arel_table
	        scope = t[:user_id].eq(user.id)
	
	        if (group_ids = user.group_ids).any?
	          scope = scope.or(t[:group_id].eq_any(group_ids))
	        end
	
	        entities.each do |klass|
	          if (asset_ids = Permission.where(scope.and(t[:asset_type].eq(klass.name))).pluck(:asset_id)).any?
	            can :manage, klass, id: asset_ids
	          end
	        end
	      end # if user.admin?
		end
    end
  end

  ActiveSupport.run_load_hooks(:fat_free_crm_ability, self)
end
