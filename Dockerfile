FROM python:3.13-alpine

WORKDIR /app

# Usuário sem privilégios para executar a aplicação.
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup

# COPY --chown=appuser:appgroup app.py /app/app.py
ADD app.py /app/app.py

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')" || exit 1

CMD ["python", "/app/app.py"]