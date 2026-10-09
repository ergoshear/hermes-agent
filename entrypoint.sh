#!/usr/bin/env bash

set -u

gateway_pid=
dashboard_pid=

stop_children() {
    if [[ -n "$gateway_pid" ]]; then
        kill "$gateway_pid" 2>/dev/null || true
    fi
    if [[ -n "$dashboard_pid" ]]; then
        kill "$dashboard_pid" 2>/dev/null || true
    fi
    if [[ -n "$gateway_pid" ]]; then
        wait "$gateway_pid" 2>/dev/null || true
    fi
    if [[ -n "$dashboard_pid" ]]; then
        wait "$dashboard_pid" 2>/dev/null || true
    fi
}

trap stop_children EXIT
trap 'exit 143' TERM
trap 'exit 130' INT

hermes gateway run &
gateway_pid=$!

hermes dashboard --host 0.0.0.0 --port 9119 --no-open &
dashboard_pid=$!

wait -n "$gateway_pid" "$dashboard_pid"
exit $?