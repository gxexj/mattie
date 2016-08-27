(library (test mattie parser)
         (export parser-tests parser-tests-for)
         (import (rnrs)
                 (mattie parser)
                 (mattie parser combinators)
                 (test util))

  (define (parser-tests-for program)
    (tests
      ("one simple rule"
       (assert (parses program "a <- b")))
      ("multiple rules"
       (assert (parses program "a <- b c <- d q <- p")))
      ("concatenation"
       (assert (parses program "a <- b c")))
      ("disjunction"
       (assert (parses program "a <- b | c")))
      ("conjunction"
       (assert (parses program "a <- b & c")))
      ("complement"
       (assert (parses program "a <- b~")))
      ("repetition"
       (assert (parses program "a <- b*")))
      ("option"
       (assert (parses program "a <- b?")))
      ("dot"
       (assert (parses program "a <- .")))
      ("terminals"
       (assert (parses program "a <- \"bc\" \"q\"")))
      ("terminals containing escaped quotes"
       (assert (parses program "a <- \"\\\"\"")))
      ("match application"
       (assert (parses program "a <- \"b\" -> q")))
      ("concatenation precedes disjunction"
       (let ((r (program "a <- b c | d" "")))
         (assert (equal? (caddr (cadr r)) 'alt))))
      ("concatenation precedes conjunction"
       (let ((r (program "a <- b c & d" "")))
         (assert (equal? (caddr (cadr r)) 'and))))
      ("conjunction precedes disjunction"
       (let ((r (program "a <- b & c | d" "")))
         (assert (equal? (caddr (cadr r)) 'alt))))
      ("parentheses"
       (let ((r (program "a <- b (c | d)" "")))
         (assert (equal? (caddr (cadr r)) 'cat))))
      ("nested parentheses"
       (assert (parses program "a <- ((b))")))
      ("multiple suffixes"
       (let ((r (program "a <- b~*?" "")))
         (assert (equal? (caddr  (cadr r)) 'opt))
         (assert (equal? (cadddr (cadr r)) 'rep))
         (assert (equal? (cadddr (cdadr r)) 'neg))))
      ("leading & trailing whitespace"
       (assert (parses program "  a <- \nb \t")))))
    
  (define parser-tests (parser-tests-for (make-language-parser))))