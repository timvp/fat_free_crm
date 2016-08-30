# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
Rails.application.routes.draw do
	
  #mount Ckeditor::Engine => '/ckeditor' 
	
  resources :lists

  root to: 'home#index'

  get 'activities' => 'home#index'
  get 'admin'      => 'admin/users#index',       :as => :admin
  get 'login'      => 'authentications#new',     :as => :login
  delete 'logout'  => 'authentications#destroy', :as => :logout
  get 'profile'    => 'users#show',              :as => :profile
  get 'signup'     => 'users#new',               :as => :signup

  get '/home/options',  as: :options
  get '/home/toggle',   as: :toggle
  match '/home/timeline', as: :timeline, via: [:get, :put, :post]
  match '/home/timezone', as: :timezone, via: [:get, :put, :post]
  post '/home/redraw',   as: :redraw

  resource :authentication, except: [:index, :edit]
  resources :comments,       except: [:new, :show]
  resources :emails,         only: [:destroy]
  resources :passwords,      only: [:new, :create, :edit, :update]

  resources :accounts, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :campaigns, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :leads
      get :opportunities
    end
  end

  resources :contacts, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
      post :send_multiple_mails
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :opportunities
      get :send_mail
    end
  end

  resources :leads, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
      get :autocomplete_account_name
    end
    member do
      get :convert
      post :discard
      post :subscribe
      post :unsubscribe
      put :attach
      match :promote, via: [:patch, :put]
      put :reject
    end
  end

  resources :opportunities, id: /\d+/ do
    collection do
      get :advanced_search
      post :filter
      get :options
      get :field_group
      match :auto_complete, via: [:get, :post]
      get :redraw
      get :versions
    end
    member do
      put :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
    end
  end

  resources :tasks, id: /\d+/ do
    collection do
      post :filter
      match :auto_complete, via: [:get, :post]
    end
    member do
      put :complete
      put :uncomplete
    end
  end

  resources :users, id: /\d+/, except: [:index, :destroy] do
    member do
      get :avatar
      get :password
      match :upload_avatar, via: [:put, :patch]
      patch :change_password
      post :redraw
    end
    collection do
      match :auto_complete, via: [:get, :post]
      get :opportunities_overview
    end
  end

  namespace :admin do
    resources :groups

    resources :users do
      collection do
        match :auto_complete, via: [:get, :post]
      end
      member do
        get :confirm
        put :suspend
        put :reactivate
      end
    end

    resources :field_groups, except: [:index, :show] do
      collection do
        post :sort
      end
      member do
        get :confirm
      end
    end

    resources :fields do
      collection do
        match :auto_complete, via: [:get, :post]
        get :options
        get :redraw
        post :sort
        get :subform
      end
    end

    resources :tags, except: [:show] do
      member do
        get :confirm
      end
    end

    resources :fields, as: :custom_fields
    resources :fields, as: :core_fields

    resources :settings, only: :index
    resources :plugins,  only: :index
  end
  
      #Toegevoegd door Effict
   resources :training_targets
   resources :evaluations
   resources :training_dates
  
  #resources :trainers, :path => "/contacts"
  
   resources :trainers, :controller => :contacts do
     collection do
       post :auto_complete, :controller => :contacts
     end
   end
  
  resources :trainings, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      match :auto_complete, via: [:get, :post]
      post :redraw
      get :versions
    end
    member do
      put  :attach
      get  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
      get :screening_report
    end
  end
  
  resources :training_dates, :id => /\d+/ do
    member do
      put :cancel
      put :confirm
    end
  end  
  
  resources :evaluations, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      match :auto_complete, via: [:get, :post]
      post :redraw
      get :versions
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
    end
  end
  
  resources :mailings, :id => /\d+/ do
    member do
      get  :show_preview
      post :deliver_test
      post :deliver
      put  :attach
      post :discard
      post :add_list
      get  :duplicate
    end
    collection do 
      get  :options 
      post :redraw
    end
  end
  
  
  resources :email_compositions
  
  resources :mailinglists do
	collection do
      get  :options
      get  :search
      match :auto_complete, via: [:get, :post]
      post :redraw
    end
    member do
      put :attach
      post :discard
    end
  end
  
  resources :documents, :id => /\d+/ do
    member do
      get :download
    end
  end

  resources :web_actions, :id => /\d+/ do
    collection do
      post :create_lead
    end
  end
  
#   namespace :portal do
#     root to: "portal#index"
#     match '/portal/show_profile',  :as => :show_profile
#     match '/contact', :controller => :portal, :action => :contact, :as => :contact
#     match '/portal/save_profile/:id', :controller => :portal, :action => :save_profile, :as => :save_profile
#     resources :trainings
#     resources :training_dates, :id => /\d+/ do
#       member do
#         put :cancel
#         put :confirm
#       end
#     end
#     resources :comments
#     resources :participants
#     resources :evaluations
#     resources :documents, :id => /\d+/ do
#       member do
#         get :download
#       end
#     end
#     #resources :products
#     #resources :widgets
#   end

  
end
