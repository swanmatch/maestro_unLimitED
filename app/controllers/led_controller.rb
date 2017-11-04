class LedController < ApplicationController

  def play
    stop_action
    unicorn_thread =
      Thread.new do
        LED.play2
      end
    unicorn_thread[:name] = 'MIDIListener'
    sleep 1
    redirect_to root_path
  end

  def stop
    stop_action
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
        th[:name] == 'MIDIListener'
      }.each{|th|
        th.kill
       }
    end
end
