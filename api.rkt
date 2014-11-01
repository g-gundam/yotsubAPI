#lang racket
(require json)
(require net/http-client)

;; 4chan API HTTP Client
(provide 4chan-data)
(provide 4chan-data-page)
(provide 4chan-data-catalog)
(provide 4chan-data-thread)

;; 4chan Data Helpers
(provide 4chan-catalog-search)
(provide 4chan-thread-match-fn)
(provide 4chan-thread-is-lisp-general?)
(provide 4chan-catalog-search-g-lisp-general)
(provide 4chan-thread-url)

;; Functions
(define (4chan-data board x)
  (let*-values
      ([(status headers res)
        (http-sendrecv "a.4cdn.org"
                       (string-append "/" board "/" x ".json"))]
       [(json) (read-string 1048576 res)]
       [(data) (string->jsexpr json)])
    data))

(define (4chan-data-page board n)
  (4chan-data board (number->string n 10)))

(define (4chan-data-catalog board)
  (4chan-data board "catalog"))

(define (4chan-data-thread board id)
  (4chan-data (string-append board "/thread") (number->string id)))

(define (4chan-catalog-search catalog pattern)
  (let* ([maybe-match
          (filter
           (4chan-thread-match-fn pattern)
           (flatten
            (map (lambda (page) (hash-ref page 'threads)) catalog)))])
    (if (empty? maybe-match)
        '()
        maybe-match)))

(define (4chan-thread-match-fn pattern)
  (lambda (thread)
    (or
     (and (hash-has-key? thread 'sub)
          (regexp-match pattern (hash-ref thread 'sub)))
     (and (hash-has-key? thread 'com)
          (regexp-match pattern (hash-ref thread 'com))))))

(define (4chan-thread-is-lisp-general? thread)
    (and (hash-has-key? thread 'sub)
         (regexp-match "Lisp General" (hash-ref thread 'sub))))

(define (4chan-thread-g-lisp-general)
  (let* ([catalog (4chan-data-catalog "g")]
        [maybe-lg
         (filter
          4chan-thread-is-lisp-general?
          (flatten
           (map (lambda (page) (hash-ref page 'threads)) catalog)))])
    (if (empty? maybe-lg)
        '()
        (car maybe-lg))))

(define (4chan-thread-url board thread)
  (string-append
   "http://boards.4chan.org/" board "/thread/"
   (number->string (hash-ref thread 'no) 10) "/"
   (hash-ref thread 'semantic_url)))
