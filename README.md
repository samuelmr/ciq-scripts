# ConnectIQ helper scripts

## Install

Clone this repository to your home directory and run the create script in that directory.

```sh
git clone https://github.com/samuelmr/ciq-scripts ~/ciq-scripts
cd ~/ciq-scripts
./create-connectiq-shortcuts.sh
```

## Usage

Create a new ConnectIQ app project
```sh
iqinit -t app MyAwesomeApp
```

Create a new ConnectIQ watch face project
```sh
iqinit -t face MyAwesomeWatchFace
```

Run current project in the default (fenix5plus) simulator
```sh
cd MyAwesomeApp
mc && md
```

Run current project in another simulator
```sh
CIQ_TARGET=marqcaptain
mc && md
```

Run current project's tests in the default simulator
```sh
mc -t && md -t
```

Another way to run tests
```sh
iqtest
```

Compile test releases for all devices
```sh
iqbeta
```

Compile a file to be uploaded to the ConnectIQ Store
```sh
iqcompile
```
