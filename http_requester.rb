require 'micromidi'
input = UniMIDI::Input.first
ip = "192.168.43.160"

puts "when stop ctr + c;"

begin
  MIDI.using(input) do
    receive :note do |message|
      if 36 < message.velocity
        case message.note
        when 36
          # kickhttp://192.168.0.66:3000/led/flash?indexes=2,4&velocity=127&r=255&g=255&b=255
          `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}&indexes=12,14,16,18,20,22,24,26,28,30`
        when 40
          # snare
          `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}&indexes=13,15,17,19,21,23,25,27,29`
        when 57, 49
          # clash
          `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}&r=255&g=255&b=255&time=0.07`
        end
        #puts message.note
      end
    end
    join
  end
rescue Interrupt
# ignored
end
