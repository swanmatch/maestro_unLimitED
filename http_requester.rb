require 'micromidi'
input = UniMIDI::Input.first
ip = "192.168.43.160"

puts "when stop ctr + c;"

begin
  MIDI.using(input) do
    receive :note do |message|
      if 36 < message.velocity
        puts message.note
        
        case message.note
        when 36
          # kick
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&indexes=9,11,13,15,17,19,21,23,25,27\\&tn=kick`
          end
        when 40
          # snare
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&indexes=10,12,14,16,18,20,22,24,26\\&tn=snare`
          end
        when 57, 49
          # clash
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&indexes=0,2,4,6,8,54,52,50,48,46,44,42,40,38,36,34,32,30,28\\&r=255\\&g=255\\&b=255\\&time=0.05\\&tn=clash`
          end
        end
      end
    end
    join
  end
rescue Interrupt
# ignored
end
