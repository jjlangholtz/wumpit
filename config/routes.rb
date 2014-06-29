Rails.application.routes.draw do
  root 'static_pages#home'

  get 'games/bat'

  get 'games/lose'

  get 'games/move'
  post 'games/move'

  get 'games/resume'

  get 'games/shoot_back'
  get 'games/shoot_left'
  get 'games/shoot_right'

  get 'games/start'

  get 'games/win'
end
