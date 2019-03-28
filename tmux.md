## Custom tmux setting

Note: the default `Ctrl+b` is replaced with the customized shortcut `Ctrl+space`.


## Sessions

Show sessions:		Ctrl+space  s
			or `tmux ls`

New session:		`tmux new -s foo`

Attach to session:	`tmux a`
			`tmux a -t foo`

Detach from session:	Ctrl-b d
			or `tmux detach`

Kill session:		`tmux kill-session -t foo`


## Key commands (after Ctrl+space)

	? = help
	s = list sessions
	$ = rename current session
	d = detach
	
#### Windows

	c = create new window
	, = rename current window
	w = list windows
	% = split horizontally
	" = split vertically
	n = change to next window
	p = change to previous window
	0-9 = select window

#### Panes

	% = create horizontal pane
	" = create vertical pane
	h = move to the left pane
	j = move to the pane below
	l = move to the right pane
	k = move to the pane above
	q = show pane numbers
	o = toggle between panes
	} = swap with next pane
	{ = swap with previous pane
	! = break the pane out of the window
	x = kill the current pane
	t = show time in current pane

#### Other

	] = scroll mode (q to exit)
