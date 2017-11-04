class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :exception

  before_action :unicorn_play?
  def unicorn_play?
    @unicorn_playing =
      Thread.list.find_all{|th|
        th[:name] == 'unicorn_hat'
      }.present?
  end

end
