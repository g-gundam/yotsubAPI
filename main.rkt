#lang racket/base
(require json
         net/http-client
         racket/contract
         racket/list)


(provide
 (contract-out
  ;; 4chan API HTTP Client
  [4chan-data (-> string? (or/c string? number?) (listof hash-eq?))]
  [4chan-data-page (-> string? number? (listof hash-eq?))]
  [4chan-data-catalog (-> string? (listof hash-eq?))]
  [4chan-data-thread (-> string? number? (listof hash-eq?))]
  ;; 4chan Data Helpers
  [4chan-catalog-search
   (-> hash-eq? (or/c regexp? byte-regexp? string? bytes?) (listof hash-eq?))]
  [4chan-thread-match-fn
   (-> (or/c regexp? byte-regexp? string? bytes?)
       (-> hash-eq? boolean?))] ; returns a procedure
  [4chan-thread-is-lisp-general? (-> hash-eq? boolean?)]
  [4chan-thread-is-dpt? (-> hash-eq? boolean?)]
  [4chan-catalog-find-lisp-general (-> (listof hash-eq?) hash-eq?)]
  [4chan-catalog-find-dpt (-> (listof hash-eq?) hash-eq?)]
  [4chan-thread-url (-> string? hash-eq? string?)]))

;;
;; Implementation
;;

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

; searches both the subject and comments fields
(define (4chan-thread-match-fn pattern)
  (lambda (thread)
    (or
     (and (hash-has-key? thread 'sub)
          (regexp-match pattern (hash-ref thread 'sub)))
     (and (hash-has-key? thread 'com)
          (regexp-match pattern (hash-ref thread 'com))))))

(define (4chan-thread-is-lisp-general? thread)
  (and (hash-has-key? thread 'sub)
       (regexp-match #rx"(?i:Lisp General)" (hash-ref thread 'sub))))

(define 4chan-thread-is-dpt? (4chan-thread-match-fn #rx"(?i:Daily Programming Thread)"))

; Find first lisp general if possible
; This may return a single thread while 4chan-catalog-search returns a list of threads.
(define (4chan-catalog-find-lisp-general catalog)
  (let* ([maybe-lg
          (filter
           4chan-thread-is-lisp-general?
           (flatten
            (map (lambda (page) (hash-ref page 'threads)) catalog)))])
    (if (empty? maybe-lg)
        (make-hasheq)
        (car maybe-lg))))

; same, but for Daily Programming Thread
(define (4chan-catalog-find-dpt catalog)
  (let* ([maybe-lg
          (filter
           4chan-thread-is-dpt?
           (flatten
            (map (lambda (page) (hash-ref page 'threads)) catalog)))])
    (if (empty? maybe-lg)
        (make-hasheq)
        (car maybe-lg))))

(define (4chan-thread-url board thread)
  (string-append
   "http://boards.4chan.org/" board "/thread/"
   (number->string (hash-ref thread 'no) 10) "/"
   (hash-ref thread 'semantic_url)))
