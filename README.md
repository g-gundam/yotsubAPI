# yotsubAPI | よつばぴー

A Racket Client for the [4chan API](https://github.com/4chan/4chan-API)

![Yotsuba](http://i.imgur.com/QM7sA6j.jpg)

## Installation

From [pkgs.racket-lang.org](http://pkgs.racket-lang.org/):
```sh
raco pkg install yotsubAPI
```

From Source:

```sh
git clone https://gitlab.com/g-gundam/yotsubAPI.git
cd yotsubAPI
raco pkg install
```

## Usage

```racket
(require yotsubAPI)
(define catalog (4chan-data-catalog "g"))
(define lispg (4chan-catalog-find-lisp-general catalog))
```

## Documentation

There's a bug in pkgs.racket-lang.org where documentation links are redirected
to the wrong URL if the package has capital letters in it.  Perhaps I should
make the name all lower case, but for now, you can view the documentation by
going here:

[http://pkg-build.racket-lang.org/doc/yotsubAPI/index.html](http://pkg-build.racket-lang.org/doc/yotsubAPI/index.html) 

## Used By

* [zero808/ya4cid](https://github.com/zero808/ya4cid) - Yet another 4chan image downloader

