FROM nousresearch/hermes-agent:v0.21.6

ENV OPENAI_BASE_URL=https://olla.ergoshear.dev/olla/openai/v1 \
	OPENAI_API_KEY=olla \
	OLLA_MODEL=llama3

COPY --chmod=0755 configure-olla.sh /etc/cont-init.d/018-olla-config
RUN sed -i 's/\r$//' /etc/cont-init.d/018-olla-config

CMD ["gateway", "run"]
