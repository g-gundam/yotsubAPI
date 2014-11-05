# yotsubAPI

A Racket Client for the [4chan API](https://github.com/4chan/4chan-API)

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
