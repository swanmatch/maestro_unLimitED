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

  def unicorn_play
    unicorn_stop_action
    unicorn_thread =
      Thread.new do
        LED.play2
        #while(true) do end
      end
    unicorn_thread[:name] = 'unicorn_hat'
    sleep 1
    unicorn_play?
    redirect_to root_path
  end

  def unicorn_stop
    unicorn_stop_action
    unicorn_play?
    redirect_to root_path
  end

  def unicorn_stop_action
    Thread.list.find_all{|th|
      th[:name] == 'unicorn_hat'
    }.each{|th|
      th.kill
    }
  end

  def flash
    Thread.new do
      LED.flash
    end
    render nothing: true
  end
end
