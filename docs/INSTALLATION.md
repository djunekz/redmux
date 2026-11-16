# Installation and Testing

## Install from source

```bash
pkg update
pkg install git
git clone https://github.com/djunekz/redmux.git
cd redmux
chmod +x redmux
./redmux setup
```

## Install a desktop

```bash
redmux install
```

Follow the prompts to select a distribution and one or more desktop environments. Keep the device connected to a reliable network and ensure adequate free storage. Do not close Termux while package configuration is running.

## Launch

Install/open the Android Termux:X11 app, then run:

```bash
redmux start
```

## Developer checks

```bash
bash -n redmux
for file in core/*.sh modules/*.sh; do bash -n "$file" || exit 1; done
```

Syntax checks do not prove that APT package names, PRoot-Distro behavior, Android app integration, or desktop sessions work on every device. Those require real-device integration testing.
