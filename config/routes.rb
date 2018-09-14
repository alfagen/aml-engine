# frozen_string_literal: true

AML::Engine.routes.draw do
  concern :archivable do
    member do
      delete :archive
      post :restore
    end
  end

  resources :document_kinds, only: %i[index new create show] do
    concerns :archivable
  end
  resources :document_groups, only: %i[index new create show] do
    concerns :archivable
  end
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
  resources :document_fields, only: %i[edit update]
  resources :order_documents, only: %i[show index edit update] do
    member do
      put :accept
      put :reject
    end
  end
end
