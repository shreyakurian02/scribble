# frozen_string_literal: true

Rails.application.routes.draw do
  constraints(lambda { |req| req.format == :json }) do
    namespace :api do
      namespace :v1 do
        resources :categories, except: %i[new show edit]
        resources :redirections, except: %i[new show edit]
        resource :site, only: %i[show update]

        resources :articles, except: %i[edit new] do
          collection do
            resource :report, only: %i[create], module: :articles do
              get :download, on: :collection
            end
          end
          resources :versions, only: %i[show], module: :articles do
            put "restore", on: :member
          end
        end

        namespace :bulk do
          resource :articles, only: %i[update destroy]
        end

        namespace :public do
          resource :site, only: :show
          resource :session, only: :create
          resources :categories, only: :index
          resources :articles, only: %i[index show], param: :slug do
            resource :like, only: %i[create destroy]
          end
        end
      end
    end
  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
