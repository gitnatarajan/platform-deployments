apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{APP_NAME}}
spec:
  rules:
  - host: {{APP_NAME}}.dev.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{APP_NAME}}
            port:
              number: 80