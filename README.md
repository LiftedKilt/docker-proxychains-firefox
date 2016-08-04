This container spawns an instance of devurandom's devurandom/firefox which is sent to a socks proxy over an ssh tunnel. This allows you to run a containerized version of firefox (with sound and video) over ssh in a single script.

This container relies heavily on the work of devurandom - you will want to use it together with his devurandom/storage container.

launch the container via the "docker-proxychains-firefox.sh" startup script from the GitHub repository (after filling out SSH_USER/SSH_SERVER variables in script.)

Graphics are attached via X11 (no VNC) and sound goes through Pulseaudio. Be warned that this severely breaks the security of the container!
