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
    rgb = [params[:r], params[:g], params[:b]]
    color =
      if (rgb.all?)
        rgb.map(&:to_i)
      else
        LED::COLORS.sample
      end
    time = params[:time].try(:to_i)
    velocity = params[:velocity].try(:to_i) || 127
    color = LED.calc_brightness(color, velocity)
    if LED.get_brightness(indexes.first) <= color.max * 2
      Thread.list.find_all{ |th|
        th[:name] == "LEDInner"
      }.each{|th|
        th.kill
      }
      led_inner =
        Thread.new do
          LED.gradetion(indexes, color, time)
        end
      led_inner[:name] = "LEDInner"
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
