(defsystem "giteki"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("dexador"
               "jonathan")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "giteki/tests"))))

(defsystem "giteki/tests"
  :author ""
  :license ""
  :depends-on ("giteki"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for giteki"
  :perform (test-op (op c) (symbol-call :rove :run c)))
