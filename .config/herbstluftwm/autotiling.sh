#!/bin/bash

# autotiling.sh
# Author: Klejdi Janari (klejdiLOL)
# https://forum.openmandriva.org/
# Location: ~/.config/herbstluftwm/autotiling.sh

get_window_count() {
    herbstclient list_clients | wc -l
}

should_float() {
    local class
    class=$(herbstclient attr clients.focus.class 2>/dev/null)
    case "$class" in
        "obs"|"Gimp"|"Pavucontrol"|"Nm-connection-editor")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

set_layout_smart() {
    local count
    count=$(get_window_count)

    if should_float; then
        herbstclient set_attr clients.focus.floating true
    else
        herbstclient set_attr clients.focus.floating false

        if [ "$count" -ge 2 ]; then
            herbstclient load "$(herbstclient attr tags.focus.name)" \
                "(split horizontal:0.5:1 (clients max:0) (clients vertical:0))"
        else
            # Default to max layout for one window
            herbstclient load "$(herbstclient attr tags.focus.name)" \
                "(clients max:0)"
        fi
    fi
}

herbstclient --idle | while read -r hook; do
    case "$hook" in
        tag_changed*|window_focus_changed*|window_title_changed*|window_added*)
            set_layout_smart
            ;;
    esac
done
