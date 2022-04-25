### Sessions

Show sessions (`tmux ls`)

	Ctrl-b s

> Note: on some Pi's i used the customized shortcut `Ctrl-space`

New session

	tmux new -s session-name

Attach to existing session

	tmux a
	tmux a -t session-name

Detaching from session (`tmux detach`)

	Ctrl-b d

Kill session

	tmux kill-session -t session-name

See all key shortcuts

	tmux list-keys
                

### Key commands (`Ctrl-b`)

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

	% = split vertically into 2 panes
	" = split horizontally
	arrow keys = focus other pane
	o = toggle between panes

	} = swap with next pane
	{ = swap with previous pane
	! = break the pane out of the window
	x = kill the current pane

	q = show pane numbers
	t = show time in current pane
