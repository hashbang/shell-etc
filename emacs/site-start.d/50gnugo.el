;;; 50gnugo.el — Emacs startup file for the Debian gnugo package  -*- Emacs-Lisp -*-

(if (not (file-exists-p "/usr/share/emacs/site-lisp/gnugo.el"))
    (message "Package gnugo removed but not purged.  Skipping setup.")
  ;; An autoload from /usr/share/emacs/site-lisp/gnugo.el
  (autoload 'gnugo "gnugo"
    "Run gnugo in a buffer, or resume a game in progress.
Prefix arg means skip the game-in-progress check and start a new
game straight away.

You are queried for additional command-line options (Emacs supplies
\"--mode gtp --quiet\" automatically).  Here is a list of options
that gnugo.el understands and handles specially:

    --boardsize num   Set the board size to use (5--19)
    --color <color>   Choose your color ('black' or 'white')
    --handicap <num>  Set the number of handicap stones (0--9)

If there is already a game in progress you may resume it instead of
starting a new one.  See `gnugo-board-mode' documentation for more info."
    t))

;;; 50gnugo.el ends here
