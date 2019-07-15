#!/bin/sh

NAME=${POD_NAME:-hello-controller}
NAMESPACE=${POD_NAMESPACE:-crossplane-system}

help() { echo "$0 prepare|remove"; }

case "$1" in
	prepare)
		kubectl -n "$NAMESPACE" apply -k .
		;;
	remove)
		kubectl -n "$NAMESPACE" delete -k .
		;;
	help)
		help
		;;
	*)
		echo "Unknown command $1"
		help
		exit 1
		;;
esac
exit 0
