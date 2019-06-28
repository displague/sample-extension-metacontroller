#!/bin/sh

NAMESPACE=${POD_NAME:-crossplane-system}
NAME=${POD_NAMESPACE:-hello-controller}

help() { echo "$0 prepare|remove"; }

case "$1" in
	prepare)
		kubectl -n "$NAMESPACE" create configmap "$NAME" --from-file=sync.py
		kubectl -n "$NAMESPACE" apply -f controller.yaml
		kubectl -n "$NAMESPACE" apply -f webhook.yaml
		;;
	remove)
		kubectl -n "$NAMESPACE" delete configmap "$NAME"
		kubectl -n "$NAMESPACE" delete -f controller.yaml
		kubectl -n "$NAMESPACE" delete -f webhook.yaml
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
