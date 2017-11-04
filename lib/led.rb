module LED

#  COLORS = [
#    Ws2812::Color.new(255,   0,   0),
#    Ws2812::Color.new(255, 127,   0),
#    Ws2812::Color.new(255, 255,   0),
#    Ws2812::Color.new(127, 255,   0),
#    Ws2812::Color.new(  0, 255,   0),
#    Ws2812::Color.new(  0, 255, 127),
#    Ws2812::Color.new(  0, 255, 255),
#    Ws2812::Color.new(  0, 127, 255),
#    Ws2812::Color.new(  0,   0, 255),
#    Ws2812::Color.new(127,   0, 255),
#    Ws2812::Color.new(255,   0, 255),
#    Ws2812::Color.new(255,   0, 127)
#  ]
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
    input = UniMIDI::Input.first

    begin
      MIDI.using(input) do
        receive :note do |message|
          if 24 < message.velocity
#            puts message.note
#            puts "ch: " + message.channel.to_s
            #puts "NN: " + message.note.to_s
            #puts "VL: " + message.velocity.to_s
            color = COLORS[message.note % 12]
            brightness = message.velocity / 127.0
            puts brightness
            color.map! {|rgb| (rgb * brightness).to_i }
            Thread.new do
              LED.gradetion(color)
            end
          end
        end
        join
      end
    rescue Interrupt
    # ignored
    end
  end

  def self.flash(color = nil)
    HAT[12..30] = color || COLORS.sample
    HAT.show
    sleep 0.2
    HAT[12..30] = BLACK
    HAT.show
  end

  #private

    def self.gradetion(color, time = 0.05)
      color.map! do |rgb|
        if rgb <= 0
          rgb = 0
        end
        rgb
      end
      puts color.inspect
      HAT[0..11] = Ws2812::Color.new(*color)
      HAT[31..54] = Ws2812::Color.new(*color)
      HAT.show
      if color.sum != 0
        color.map! do |rgb|
          if rgb <= 0
            rgb -= 10
          end
          rgb
        end
        sleep time
        gradetion(color, time)
      end
    end
end
