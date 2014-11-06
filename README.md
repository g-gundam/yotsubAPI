# yotsubAPI

A Racket Client for the [4chan API](https://github.com/4chan/4chan-API)

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

