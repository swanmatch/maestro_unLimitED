class LedController < ApplicationController

  # http://192.168.0.66:3000/led/flash?indexes=2,4&velocity=127&r=255&g=255&b=255
  def flash
    indexes =
      if params[:indexes]
        params[:indexes].split(",").map(&:to_i)
      else
        LED::INNER
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
    LED.noteon(indexes, LED.calc_brightness(color, velocity))
    head :ok
  end
end
