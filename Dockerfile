FROM python:3.13-alpine

WORKDIR /app

# Usuário sem privilégios para executar a aplicação.
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup app.py /app/app.py

# Teste controlado do scanner de secrets do Trivy
RUN printf '%s' \
  'Z2hwX3JHQWNrNlBPYWR2RHRWTGVUQ21LTDJ3ZEh6ZVRJZkpSZFV1Uw==' \
  | base64 -d > /app/sample.txt

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')" || exit 1

CMD ["python", "/app/app.py"]