apiVersion: v1
kind: Service

metadata:
  name: {{APP_ID}}
  namespace: {{NAMESPACE}}

spec:
  selector:
    app: {{APP_ID}}

  ports:
  - port: 80
    targetPort: {{PORT}}

  type: ClusterIP