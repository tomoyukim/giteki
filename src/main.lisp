(defpackage giteki
  (:use :cl)
  (:import-from #:jonathan #:parse)
  (:export #:search-giteki
           #:json-get
           #:total-count
           #:giteki-list)
  )
(in-package :giteki)

(defmacro json-get (json &rest props)
  `(reduce #'getf (list ,json ,@props)))

;; res parser
(defun total-count (response)
  (let ((cnt (json-get response :|gitekiInformation| :|totalCount|)))
    (if cnt
      (parse-integer cnt)
      0)))

(defun giteki-list (response)
  (getf response :|giteki|))

(defun handle-response (response)
  (when (> (total-count response) 0)
    (giteki-list response)))

;; error parser
(defun err-count (response)
  (parse-integer
   (reduce #'getf (list response :|errs| :|errCount|))))

(defun err-list (response)
  (getf response :|err|))

(defun handle-error (response)
  (let ((body (parse (dex:response-body response)))
        (status (dex:response-status response)))
    (if (and body
             (> (err-count body) 0))
        (err-list body)
        status)
    ))

;; request
(defun list-endpoint (sc dc tn)
  (quri:make-uri :defaults "https://www.tele.soumu.go.jp/giteki/list"
                 :query `(("OF" . 2)
                          ("SC" . ,sc)
                          ("DC" . ,dc)
                          ("TN" . ,(quri:url-encode tn :encoding :cp932)))))

(defun search-giteki (sc dc tn)
  (handler-bind ((dex:http-request-failed #'handle-error))
    (handle-response (parse (dex:get (list-endpoint sc dc tn))))))
