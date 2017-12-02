require 'micromidi'
input = UniMIDI::Input.first
ip = "192.168.43.160"

puts "when stop ctr + c;"

begin
  MIDI.using(input) do
    receive :note do |message|
      #if 36 < message.velocity
        puts message.note
        case message.note
        when 36
          # kick
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&indexes=12,14,16,18,20,22,24,26,28,30\\&tn=kick`
          end
        when 40
          # snare
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&indexes=13,15,17,19,21,23,25,27,29\\&tn=snare`
          end
        when 57, 49
          # clash
          Thread.new do
            `curl -s http://#{ip}:3000/led/flash?velociity=#{message.velocity}\\&r=255\\&g=255\\&b=255\\&time=0.07\\&tn=kick,snare`
          end
        end
      #end
    end
    join
  end
rescue Interrupt
# ignored
end
