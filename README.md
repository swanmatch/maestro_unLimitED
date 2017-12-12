# Lightning Guitar Project

This is 86LEDs controlable Web Application for raspberry pi.

https://prezi.com/p/mc090rn48iy1/

Be root user before rounch this application.
```sh
sudo su
rails s -production
```

Auto analysis beat and chords from youtube, niconico douga, and sound cloud music by songle.
When music playing, display current chord and guitar lightning on the beat.

MIDI drum machine(and other) send LED control API,
when hit crash, bass, and snare drum's note on event.

Please connect MIDI device and type this on project folder.
```sh
ruby -s http_requester
```
// install "curl" before.
