require "resque/scheduler/server"

Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"
  resources :jobs, only: :index
end
