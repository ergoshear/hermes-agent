#!/command/with-contenv sh
set -eu

hermes_cli=/opt/hermes/.venv/bin/hermes
s6-setuidgid hermes "$hermes_cli" config set model.provider custom:olla
s6-setuidgid hermes "$hermes_cli" config set providers.olla.api "$OPENAI_BASE_URL"
s6-setuidgid hermes "$hermes_cli" config set providers.olla.api_key "$OPENAI_API_KEY"
s6-setuidgid hermes "$hermes_cli" config set providers.olla.transport chat_completions
s6-setuidgid hermes "$hermes_cli" config set model.default "$OLLA_MODEL"

plugin_dir=/opt/data/plugins/superpowers
install -d -o hermes -g hermes /opt/data/plugins
if [ -d "$plugin_dir" ]; then
	s6-setuidgid hermes "$hermes_cli" plugins enable superpowers
else
	s6-setuidgid hermes "$hermes_cli" plugins install obra/superpowers --enable --yes-deps --force
fi
