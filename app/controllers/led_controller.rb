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
    indexes = params[:indexes].try(:split, ",") || (12..30)
    color = params[:color],
    time = params[:time]
    Thread.list.find_all{ |th|
      th[:name] == 'LEDInner'
    }.each{|th|
      th.kill
    }
    puts color
#    led_flame = Thread.new do
        LED.gradetion(indexes, color, time)
#      end
    led_flame[:name] = 'LEDInner'
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
