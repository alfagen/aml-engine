# frozen_string_literal: true

AML::Engine.routes.draw do
  scope module: :aml do
    # default_url_options Settings.default_url_options.symbolize_keys

    root to: redirect('/orders')

    concern :archivable do
      member do
        delete :archive
        post :restore
      end
    end

    get 'login' => 'user_sessions#new', :as => :login
    delete 'logout' => 'user_sessions#destroy', :as => :logout
    resources :password_resets, only: %i[new create edit update]
    resource :password, only: %i[edit update]
    resources :user_sessions, only: %i[new create destroy]
    resources :users, except: %i[show destroy] do
      member do
        put :block
        put :unblock
      end
    end
    resources :document_kinds, only: %i[index new create show]
    resources :document_kind_field_definitions, only: %i[new create edit update] do
      concerns :archivable
    end
    resources :clients, except: %i[edit update destroy]
    resources :orders do
      member do
        put :in_process
        put :accept
        put :reject
        put :stop
      end
    end
    resources :client_document_fields, only: %i[edit update]
    resources :client_documents, only: %i[show index new create] do
      member do
        put :accept
        put :reject
      end
    end
  end
end
