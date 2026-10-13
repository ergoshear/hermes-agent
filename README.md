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

## Olla Provider

The image routes inference through `https://olla.ergoshear.dev/olla/openai/v1`
using model `qwen3-coder-next` and the OpenAI-compatible
chat-completions API. The `olla` API key is a placeholder, not a secret.
Olla currently advertises these model IDs at `/v1/models`:

- `nomic-embed-text-v1.5`
- `qwen2.5-coder-7b-instruct`
- `qwen3-coder-next`
- `Qwen3.6-27B`
- `Qwen3.8-27B`

Hermes defaults to `qwen3-coder-next`; coding-agent tool use requires a
model/backend that supports tool calls.

The `018-olla-config` startup hook runs after the upstream home initialization
and before gateways start. It configures Olla under the `custom` provider
entry (`model.provider: custom`) with its endpoint, API key, and
chat-completions transport, then selects the default model. This makes the
provider explicit in Hermes' `providers:` configuration and updates existing
PVCs without losing dashboard or session data.
It also installs and enables the Superpowers plugin on first startup, including
for existing PVCs, and ensures it stays enabled on later starts. The initial
install overrides Hermes' caution scan because this plugin source is explicitly
trusted. These settings are reapplied on every container start. Override `OPENAI_BASE_URL`,
`OPENAI_API_KEY`, or `OLLA_MODEL` in the deployment to change the defaults.
Separate named profiles and per-session model overrides retain their own settings.

Rebuild and publish the image, then restart the Hermes deployment. The GitOps
overlay replaces the old direct LM Studio URL with Olla's HTTPS endpoint.
