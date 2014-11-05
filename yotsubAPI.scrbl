#lang scribble/manual
@(require (for-label racket/base
                     "main.rkt"))

@title{4chan API Client Library}

@defmodule[yotsubAPI]

yotsubAPI is an interface to the 4chan JSON API.

@section{Procedures}

@defproc[(4chan-data [board string?] [x (or/c string? number?)]) hasheq?]{
  This procedure is used as the backbone for many other procedures.

  It takes a board identifier (e.g. "g" or "a") and either a thread number
  or the string "catalog".
}

@defproc[(4chan-data-page [board string?] [n number?]) hasheq?]{
  This procedure takes a board identifier as a string and a page number
  and returns a @racket[hasheq] with information about the page.
}

@defproc[(4chan-data-catalog [board string?]) hasheq?]{
  This procedure takes a board identifier and returns a @racket[hasheq]
  containing information about that board's catalog.
}

@defproc[(4chan-data-thread [board string?] [id number?]) hasheq?]{
  This procedure takes a board identifier and a thread number and
  returns a @racket[hasheq] containing the information about that thread.
}

@defproc[(4chan-catalog-search [catalog hasheq?]
                               [pattern (or/c regexp? byte-regexp? string? bytes?)]) hasheq?]{
  This procedure takes a hasheq (created from running @racket[4chan-data-catalog])
  and a pattern to search and returns a hasheq containing the search results.
}

@defproc[(4chan-thread-match-fn
          [pattern (or/c regexp? byte-regexp? string? bytes?)]) procedure?]{
  This procedure is a helper procedure where you provide a pattern and
  it will return a procedure that you apply to a thread's @racket[hasheq].
}

@defproc[(4chan-thread-is-lisp-general? [thread hasheq?]) boolean?]{
  This procedure is a helper procedure takes takes a thread's @racket[hasheq]
  and will return a boolean value.
}

@defproc[(4chan-catalog-find-lisp-general [catalog hasheq?]) hasheq?]{
  This procedure takes a catalog's @racket[hasheq] and returns the @racket[hasheq]
  for the first Lisp General it finds, if it exists.
}

@defproc[(4chan-thread-url [board string?] [thread number?]) string?]{
  This procedure takes a board identifier and a thread number and returns
  its URL as a string.
}
