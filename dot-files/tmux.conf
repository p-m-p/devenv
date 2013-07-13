set -g default-terminal "screen-256color"
setw -g mode-mouse off

### PANES ----------------------------------
# Pane movement like Vi
bind -r h select-pane -L
bind -r j select-pane -D 
bind -r k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Split panes
bind | split-window -h
bind - split-window -v

# pane colours
set -g pane-border-fg colour240
set -g pane-border-bg colour235
set -g pane-active-border-fg colour180
set -g pane-active-border-bg colour238

### STATUS BAR ----------------------------
set -g status-utf8 on
set -g status-justify centre
set -g status-interval 60
setw -g monitor-activity on
set -g visual-activity on

# Bar colours
set -g status-fg white
set -g status-bg colour238

# Window list
setw -g window-status-fg colour238
setw -g window-status-bg colour248
setw -g window-status-attr dim
setw -g window-status-current-fg green
setw -g window-status-current-bg colour238
setw -g window-status-current-attr bright

# Command line
set -g message-fg yellow
set -g message-bg colour238 
set -g message-attr bright

# Left side
set -g status-left-length 40
set -g status-left "#[fg=colour156]Session: #S #[fg=colour87]#I #[fg=colour219]#P"

# Right side
set -g status-right "#[fg=colour253]%d %b %R"
