#!/command/with-contenv sh
set -eu

hermes_cli=/opt/hermes/.venv/bin/hermes
s6-setuidgid hermes "$hermes_cli" config set model.provider custom
s6-setuidgid hermes "$hermes_cli" config set model.base_url "$OPENAI_BASE_URL"
s6-setuidgid hermes "$hermes_cli" config set model.api_key "$OPENAI_API_KEY"
s6-setuidgid hermes "$hermes_cli" config set model.default "$OLLA_MODEL"
s6-setuidgid hermes "$hermes_cli" config set model.api_mode chat_completions