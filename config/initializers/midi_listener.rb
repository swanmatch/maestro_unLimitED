# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

unicorn_thread =
  Thread.new do
    LED.play
  end
unicorn_thread[:name] = 'MIDIListener'
