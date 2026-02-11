Rails.application.routes.draw do
  root 'tasks#index'          # ← This line makes localhost:3000 load your Tasks index
  resources :tasks            # Gives you /tasks, /tasks/new, /tasks/1, etc.
end