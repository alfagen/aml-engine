AML::Engine.routes.draw do
  root to: redirect('orders#index')
  get 'error' => 'application#error'
  delete 'reset_db' => 'application#reset_db'
  delete 'drop_clients' => 'application#drop_clients'
  delete 'drop_orders' => 'application#drop_orders'
  resources :agreements
  resources :notifications
  resources :notification_templates, only: %i[update create]
  resources :operators, except: %i[show destroy] do
    member do
      put :block
      put :unblock
    end
  end
  concern :archivable do
    member do
      delete :archive
      post :restore
    end
  end
  resources :check_lists
  resources :statuses
  resources :document_group_to_statuses, only: %i[create destroy]
  resources :document_groups, except: %i[destroy] do
    concerns :archivable
    resources :document_kinds do
      concerns :archivable
      resources :document_kind_field_definitions do
        concerns :archivable
      end
    end
  end
  resources :clients, except: %i[edit destroy] do
    member do
      delete :reset
    end
  end
  resources :client_infos
  resources :orders do
    resources :checks, controller: :order_checks do
      member do
        put :accept
        put :reject
      end
    end
    resources :rejections, only: [:new, :create], controller: :order_rejections
    member do
      put :done
      put :start
      put :accept
      put :reject
      put :cancel
    end
  end
  resources :document_fields, only: %i[edit update]
  resources :order_documents, only: %i[show index edit update] do
    resources :rejections, only: [:new, :create], controller: :order_document_rejections
    member do
      put :accept
      put :reject
    end
  end
  resources :payment_card_orders do
    resources :rejections, only: [:new, :create], controller: :payment_card_order_rejections
    member do
      put :done
      put :start
      put :accept
      put :reject
      put :cancel
    end
  end
  resources :reject_reasons
end
