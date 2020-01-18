#!/bin/zsh

if [ "$1" = "" ]; then
    echo "ERROR: project name is a required positional argument"
    exit 1
fi

proj="$1"
proj_dir="$PWD"/"$1"

# Scaffold out folders and files
mkdir "$proj_dir"
touch "$proj_dir/$proj.asd"
touch "$proj_dir/$proj.lisp"
touch "$proj_dir/package.lisp"
mkdir "$proj_dir/tests"
touch "$proj_dir/tests/main.lisp"
touch "$proj_dir/tests/package.lisp"

# Initialize files with minimum info
# $proj.asd
echo "(asdf:defsystem #:$proj
    :serial t 
    :components (
		 (:file \"package\")
		 (:file \"$proj\"))
    ;;; Optional values below.
    :in-order-to ((test-op (test-op :$proj/tests)))
    :name \"$proj\"
    :version \"0.0.0\"
    :maintainer \"Theo Sherry (sherr.theo@gmail.com)\"
    :author \"Theo Sherry (sherr.theo@gmail.com)\"
    :licence \"BSD\"
    :description \"\"
    :long-description \"\")

(asdf:defsystem #:$proj/tests
  :depends-on (:$proj :fiveam)
  :components ((:module \"tests\"
			:serial t
			:components ((:file \"package\")
				     (:file \"main\"))))
  :perform (test-op (o s)
		    (uiop:symbol-call :$proj-tests :test-$proj)))" > "$proj_dir/$proj.asd"


# $proj.lisp
echo "(in-package #:$proj)

(defun foo ()
  'bar)" > "$proj_dir/$proj.lisp"

# package.lisp (main)
echo "(defpackage #:$proj
  (:use #:common-lisp)
  (:export #:foo))" > "$proj_dir/package.lisp"

# Scaffolding for tests
# package.lisp
echo "(defpackage #:$proj-tests
  (:use #:cl #:fiveam)
  (:export #:test-$proj
	   #:run!))" > "$proj_dir/tests/package.lisp"

# main.lisp (tests)
echo "(in-package #:$proj-tests)

(def-suite all-tests
    :description \"My $proj test suite\")

(in-suite all-tests)

(defun test-$proj ()
  (run! 'all-tests))

(test foo-general 
  (is (equal
       (intern \"BAR\" :$proj)
       ($proj::foo))))" > "$proj_dir/tests/main.lisp"

# Success
echo "$proj project successfully scaffolded."




