### Sessions

Show sessions (`tmux ls`)

	Ctrl-b s

> Note: customized shortcut is `Ctrl-space`

New session

	tmux new -s session-name

Attach to existing session

	tmux a
	tmux a -t session-name

Detaching from session (`tmux detach`)

	Ctrl-b d

Kill session

	tmux kill-session -t session-name


### Key commands (`Ctrl-space`)

	? = help
	s = list sessions
	$ = rename current session
	d = detach

	c = create new window
	, = rename current window
	w = list windows
	% = split horizontally
	" = split vertically
	n = change to next window
	p = change to previous window
	0-9 = select window

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
