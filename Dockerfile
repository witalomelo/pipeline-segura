FROM python:3.13-alpine

WORKDIR /app

# Usuário sem privilégios para executar a aplicação.
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup app.py /app/app.py

# Teste temporário para validar o bloqueio do Trivy
RUN printf '%s\n' \
  'AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE' \
  'AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY' \
  > /app/test-secret.env

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')" || exit 1

CMD ["python", "/app/app.py"]