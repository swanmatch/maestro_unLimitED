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

  # http://192.168.0.66:3000/led/flash?indexes=2,4&velocity=127&r=255&g=255&b=255
  def flash
    indexes =
      if params[:indexes]
        params[:indexes].split(",").map(&:to_i)
      else
        12..30
      end
    rgb = [params[:r], params[:g], params[:b]]
    color =
      if (rgb.all?)
        rgb.map(&:to_i)
      else
        LED::COLORS.sample
      end
    time = params[:time].try(:to_f)
    velocity = params[:velocity].try(:to_i) || 127
    thread_name =
      if params[:tn]
        params[:tn]
      else
        "LEDInner"
      end
    color = LED.calc_brightness(color, velocity)
    if LED.get_brightness(indexes.first) <= color.max
      Thread.list.find_all{ |th|
        thread_name.split(",").map { |tn|
          th[:name].include? tn
        }.any?
      }.each{ |th|
        th.kill
      }
      led_inner =
        Thread.new do
          LED.gradetion(indexes, color, time)
        end
      led_inner[:name] = thread_name
    end
    head :ok
  end

  private
    def stop_action
      Thread.list.find_all{ |th|
        th[:name] == 'MIDIListener'
      }.each{|th|
        th.kill
       }
    end
end
