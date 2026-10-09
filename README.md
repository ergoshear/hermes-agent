# hermes-agent

The container runs both the Hermes gateway and its web dashboard. The dashboard
is exposed on port `9119` and requires HTTP Basic Auth on the trusted cluster
network.

Before applying the GitOps manifests, create the dashboard credentials in the
`agents` namespace. Keep the password and stable session-signing secret outside
Git:

```sh
kubectl -n agents create secret generic hermes-dashboard-auth \
	--from-literal=username=admin \
	--from-literal=session-secret='<at-least-32-random-bytes>'
```

The dashboard URL is `http://<Hermes LoadBalancer IP>:9119/`. The Hermes home
directory is persisted in a 5 GiB PVC so dashboard-managed configuration and
sessions survive pod replacement.