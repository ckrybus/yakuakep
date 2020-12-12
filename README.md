# yakuakep

[Yakuake](https://apps.kde.org/en/yakuake) session manager, build with [Nim](https://nim-lang.org/).

**Beware: it works, but it's still very early in the development.**

## Installation

A precompiled binary for Linux AMD 64 of the latest version of `yakuakep` can be obtained under the [Releases tab](https://github.com/ckrybus/yakuakep/releases).

You might need to install a dbus client.

If you are using ubuntu you can install the `qdbus` binary with:

```bash
sudo apt-get install qdbus-qt5
```

## Features

- display yakuake tabs
- save yakuake tabs to a json file
- restore yakuake tabs from a json file 

## Usage

For now only a very basic interface exists

```bash
$ yakuakep ps   # show all tabs
$ yakuake save  # save tabs
$ yakuake load  # load previously saved tabs
```

## Limitations

In yakuake you can have multiple terminals per tab, but `yakuakep` currently only supports one terminal per tab.

Works via dbus.

## Contributing, bug reports, requests

Welcome❤

## License

MIT License. Please see [License File](LICENSE) for more information.

