# yotsubAPI

A Racket Client for the [4chan API](https://github.com/4chan/4chan-API)

## Installation

From Source

```sh
git clone https://gitlab.com/g-gundam/yotsubAPI.git
raco link yotsubAPI
```

TODO:  Figure out how to contribute this to [planet.racket-lang.org](http://planet.racket-lang.org)
and/or [pkgs.racket-lang.org](pkgs.racket-lang.org).

## Usage

```racket
(require yotsubAPI)
(define catalog (4chan-data-catalog "g"))
(define lispg (4chan-catalog-find-lisp-general catalog))
```

## TODO

- package this up so that people can install it easily.
- document the code
- implement functions for threads, replies, images, and thumbnails route
