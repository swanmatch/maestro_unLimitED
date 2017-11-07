module LED

#  COLORS = [
#    [255,   0,   0],
#    [255, 127,   0],
#    [255, 255,   0],
#    [127, 255,   0],
#    [  0, 255,   0],
#    [  0, 255, 127],
#    [  0, 255, 255],
#    [  0, 127, 255],
#    [  0,   0, 255],
#    [127,   0, 255],
#    [255,   0, 255],
#    [255,   0, 127]
#  ]

  COLORS = [
    [230,   0,  18],
    [243, 152,   0],
    [255, 251,   0],
    [143, 195,  31],
    [  0, 153,  68],
    [  0, 158, 150],
    [  0, 160, 233],
    [  0, 104, 183],
    [ 29,  32, 136],
    [146,   7, 131],
    [228,   0, 127],
    [229,   0,  79]
  ]

  HAT = Ws2812::Basic.new(55, 18).open

  def self.play2
    puts 'listen!'
    input = UniMIDI::Input.first
    indexes = [(0..11).to_a, (31..54).to_a].flatten

    begin
      MIDI.using(input) do
        receive :note do |message|
          if 38 < message.velocity
#            puts message.note
#            puts "ch: #{message.channel}"
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
                  LED.gradetion(indexes, color)
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

  def self.gradetion(indexes, color, time = 0.05)
    time  ||= 0.05
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
      LED.gradetion(indexes, color, time)
    end
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
