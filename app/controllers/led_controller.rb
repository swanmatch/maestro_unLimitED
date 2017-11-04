class LedController < ApplicationController

  def play
    stop_action
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

  def stop
    stop_action
    unicorn_play?
    redirect_to root_path
  end

  def flash
    Thread.new do
      LED.flash
    end
    head :ok
  end
  
  private
    def stop_action
      Thread.list.find_all{|th|
        th[:name] == 'unicorn_hat'
      }.each{|th|
        th.kill
       }
    end
end
