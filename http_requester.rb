module LED
  def self.play2
    require 'micromidi'
    input = UniMIDI::Input.first
    begin
      MIDI.using(input) do
        receive :note do |message|
          if 24 < message.velocity && message.note == 36
            #puts message.note
            `curl -s http://192.168.43.160:3000/flash`
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
end
