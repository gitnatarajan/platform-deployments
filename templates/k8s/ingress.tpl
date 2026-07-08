apiVersion: networking.k8s.io/v1
kind: Ingress

metadata:
  name: {{APP_ID}}
  namespace: {{NAMESPACE}}

spec:
  ingressClassName: traefik

  rules:
  - host: {{APP_ID}}.lab.local

    http:
      paths:
      - path: /

        pathType: Prefix

        backend:
          service:
            name: {{APP_ID}}

            port:
              number: 80