# Frequently asked questions

## On windows docker won't run (ciceda_windows.bat)

Clone the repository in a directory without spaces. 

## On windows, it complains about "bash profile" something, or USER not found.
On windows, text files usually contain line feed and return for newlines (\r\n), however, linux and mac only use line feed (\n).

There is an option in git to convert text files to windows format. That option must be turned off.


Option 1:
- remove dicex
- find the option in git, and change it. Or uninstall and install, I think there is an option during the install.
- Try again

Option 2:

```git clone https://github.com/wulffern/dicex --config core.autocrlf=input```

## Something is wrong

First try
```
git pull
```
to update your repository. Probably a good idea to do a 

```
git commit -m "My local commit" -a first
```

first, so your changes don't dissapear

If that does not work, do a 
```
docker pull wulffern/ciceda:ubuntu_latest
```

## Do I have to use VNC client if I already have a linux or mac?

No. You can forward the display via X directly. But I've experience on my mac that the X looses connections sometimes.

Assuming you're running bash/zsh (check with `echo $SHELL`)

On host
```sh
xhost +localhost
```

In ciceda
```sh
export DISPLAY=host.docker.internal:0
```

On mac you also need to enable connection from network clients (XQuartz->Preferences->Allow connections from network client)


