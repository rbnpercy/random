; Postgres test

(require 'pg)

(defun get-number-data (v) "Get the data for the given view."
  (with-pg-connection con ("number" "tits_mcgee" "blah" "n00p")
          (let ((res (pg:exec con "select * from " v)))
           (list (pg:result res :attributes)
                 (pg:result res :tuples)))))

(defun shove-data-in (b s) "Shove data in a given buffer."
  (save-excursion
    (if (not (get-buffer b))
	(generate-new-buffer b))
    (set-buffer b)
    (insert s)))

(defun show-data (d) "Show the data from the postgres result."

(shove-data-in "*results*" (get-number-data "show_account_values"))
