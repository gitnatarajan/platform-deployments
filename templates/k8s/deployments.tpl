apiVersion: apps/v1
kind: Deployment

metadata:
  name: {{APP_ID}}
  namespace: {{NAMESPACE}}

spec:
  replicas: 1

  selector:
    matchLabels:
      app: {{APP_ID}}

  template:
    metadata:
      labels:
        app: {{APP_ID}}

    spec:
      containers:
      - name: {{APP_ID}}
        image: {{IMAGE}}

        ports:
        - containerPort: {{PORT}}