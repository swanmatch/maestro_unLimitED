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
  BLACK = Ws2812::Color.new(0,0,0)
  WHITE = Ws2812::Color.new(255,255,255)

  MATRIX = [
    [  0,  0,  1,  2,  3,  0,  0,  0,  0,  0,  0,  0,  0],
    [  0,  8,  7,  6,  5,  4,  0,  0,  0,  0, 22, 21, 20],
    [  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,  0,  0],
    [ 32, 31, 30, 29, 28, 27, 26, 25, 24, 23,  0,  0,  0],
    [ 33, 34,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
    [ 36, 35,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
    [ 37, 38, 39, 40, 41, 42, 43, 44, 45,  0,  0,  0,  0],
    [  0,  0,  0,  0, 50, 49, 48, 47, 46,  0,  0,  0,  0],
    [ 51, 52, 53, 54, 55,  0,  0,  0,  0, 56, 57,  0,  0],
  ]

  HAT = Ws2812::Basic.new(55, 18).open

  def self.play2
    puts 'listen!'
    input = UniMIDI::Input.first
    indexes = [(0..11).to_a, (31..54).to_a].flatten

    begin
      MIDI.using(input) do
        receive :note do |message|
          if 24 < message.velocity
#            puts message.note
#            puts "ch: #{message.channel}"
#            puts "NN: #{message.note}"
#            puts "VL: #{message.velocity}"
            color = COLORS[message.note % 12]
            # 強い音は明るい光
            color = LED.calc_brightness(color, message.velocity)
            if [HAT[0].r, HAT[0].g, HAT[0].b].max <= color.max * 2
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
    puts color.inspect
    indexes.each do |i|
      HAT[i] = Ws2812::Color.new(*color)
    end
    HAT.show
    if color.sum != 0
      new_color=
        color.map do |rgb|
          rgb -= 5
        end
      sleep time
      LED.gradetion(indexes, new_color, time)
    end
  end

  def self.calc_brightness(color, velocity)
    brightness = (velocity + 30) / 127.0
    brightness = 1.0 if 1.0 < brightness
    color.map! {|rgb| (rgb * brightness).to_i }
  end

  def self.get_brightness(index)
    [HAT[index].r, HAT[index].g, HAT[index].b].max
  end
end
