module LED

  COLORS = [
    [255,   0,   0],
    [255, 127,   0],
    [255, 255,   0],
    [127, 255,   0],
    [  0, 255,   0],
    [  0, 255, 127],
    [  0, 255, 255],
    [  0, 127, 255],
    [  0,   0, 255],
    [127,   0, 255],
    [255,   0, 255],
    [255,   0, 127]
  ]

  HAT = Ws2812::Basic.new(86, 18).open
  FLAME = [(28..55).to_a, (0..8).to_a.reverse].flatten.reverse
  INNER = (9..27).to_a
  BODY = (56..85).to_a

  def self.play
    puts 'MIDI Lstening Now!'
    input = UniMIDI::Input.first
    indexes = BODY

    Thread.list.find_all{ |th|
      th[:name] == 'LEDGradation'
    }.each{|th|
      th.kill
    }
    led_flame =
      Thread.new do
        LED.gradation
      end
    led_flame[:name] = 'LEDGradation'

    begin
      MIDI.using(input) do
        receive :note do |message|
          if 38 < message.velocity
#            puts "CH: #{message.channel}"
#            puts "NN: #{message.note}"
#            puts "VL: #{message.velocity}"
            color = COLORS[message.note % 12].dup
            # 強い音は明るい光
            color = LED.calc_brightness(color, message.velocity)
            if [HAT[0].r, HAT[0].g, HAT[0].b].max <= color.max
              Thread.list.find_all{ |th|
                th[:name] == 'LEDFlame'
              }.each{|th|
                th.kill
              }
              led_flame =
                Thread.new do
                  LED.fade(indexes, color)
                end
              led_flame[:name] = 'LEDFlame'
            end
          end
        end
        join
      end
    rescue Interrupt
    # ignored
    end
  end

  def self.fade(indexes, color, time = 0.05)
    time ||= 0.05
    loop do
      color.map! do |rgb|
        rgb = 0 if rgb < 0
        rgb
      end
  #    puts color.inspect
      indexes.each do |i|
        HAT[i] = Ws2812::Color.new(*color)
      end
      HAT.show
      if color.sum != 0
        color.map! do |rgb|
          rgb -= 5
        end
        sleep time
      else
        break
      end
    end
  end

  def self.gradation
    indexes = FLAME.select{|i| i % 2 == 1}
    size = indexes.size
    colors = Array.new size, [0,0,0]
    colors[0] = [255,255,255]
    time = 0.05
    diffs ||= [-2, -3, -5]

    loop do
      indexes.each_with_index do |index, i|
#        puts colors[i].inspect
        HAT[index] = Ws2812::Color.new(*colors[i])
      end
      HAT.show

      new_color =
        colors.first.map.with_index do |rgb, i|
          rgb += diffs[i]
          rgb = 0 if rgb < 0
          rgb = 255 if 255 < rgb
          rgb
        end
  #    puts new_color.inspect
      diffs =
        diffs.map.with_index do |diff, i|
          if new_color[i] <= 0 || 255 <= new_color[i]
            diff * -1
          else
            diff
          end
        end
      sleep time
      colors.unshift(new_color)[1..size]
    end
#    LED.gradation(indexes, colors, time, next_diffs)
  end

  def self.calc_brightness(color, velocity)
    brightness = (velocity + 30) / 127.0
    brightness = 1.0 if 1.0 < brightness
    color.map {|rgb| (rgb * brightness).to_i }
  end

  def self.get_brightness(index)
    [HAT[index].r, HAT[index].g, HAT[index].b].max
  end
end
