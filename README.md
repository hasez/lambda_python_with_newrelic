# lambda_python_with_newrelic

## start

```
$ docker compose up --build
Attaching to FastAPI
FastAPI  | INFO:     Will watch for changes in these directories: ['/var/www/html']
FastAPI  | INFO:     Uvicorn running on http://0.0.0.0:9004 (Press CTRL+C to quit)
FastAPI  | INFO:     Started reloader process [1] using watchgod
FastAPI  | INFO:     Started server process [9]
FastAPI  | INFO:     Waiting for application startup.
FastAPI  | INFO:     Application startup complete.
FastAPI  | INFO:     172.23.0.1:60106 - "GET / HTTP/1.1" 404 Not Found
FastAPI  | INFO:     172.23.0.1:60106 - "GET /favicon.ico HTTP/1.1" 404 Not Found
FastAPI  | INFO:     172.23.0.1:60108 - "GET /uuid HTTP/1.1" 200 OK
FastAPI  | INFO:     172.23.0.1:60112 - "GET /uuid HTTP/1.1" 200 OK
```

## API operation check
another console
```
$ curl http://localhost:9004/uuid
{"uuid":"c3bccec7-b4f6-459e-be65-70ebd514be18"}
```

## AWS

your AWS profile settings

## install serverless

```
$ npm install serverless
$ sls -version
Running "serverless" from node_modules
Framework Core: 2.72.3 (local)
Plugin: 5.5.4
SDK: 4.3.2
Components: 3.18.2
```

## install severless python requirements

```
npm install serverless-python-requirements
```

## serverless deploy

```
$ sls deploy --staging dev
```
After running deploy, you should see output similar to:
```
Service Information
service: inside-out-demo-app
stage: dev
region: ap-northeast-1
stack: inside-out-demo-app-dev
resources: 12
api keys:
  None
endpoints:
  ANY - https://************.execute-api.ap-northeast-1.amazonaws.com/dev/uuid
functions:
  app: inside-out-demo-app-dev-app
layers:
  pythonRequirements: arn:aws:lambda:ap-northeast-1:************:layer:inside-out-demo-app-layer:1
Serverless: Removing old service artifacts from S3...
```

## API operation check for lambda

```
$ curl https://************.execute-api.ap-northeast-1.amazonaws.com/dev/uuid
{"uuid":"2b1a2681-e207-4284-9281-efc4a5a408ca"}
```

## NewRelic Nerdlet

### Setup AWS Lambda monitoring At NewRelic
- Add more data
- Cloud and platform technologies
- Lambda
  - ① Before you start
    - Are you using the Serverless framework?
      Yes
    - Do you have a Node or Python Lambda Function to instrument?
      Yes
    - Do you want to deliver your function’s telemetry with our Lambda Extension, or through a Cloudwatch Logs subscription?
      Lambda Extension
  - ② Configure AWS using our automated script
      Choose a New Relic account
  - Then, a fragment of serverless.yml is output
  - Copy a fragment of serverless.yml and Paste into serverless.yml

### Install New Relic Serverless framework plug-in

- install plug-in
  ```
  $ npm install serverless-newrelic-lamda-layers
  ```

- add to serverless.yml
  ```diff
  plugins:
    - serverless-python-requirements
  + - serverless-newrelic-lambda-layers
  ```

- Deploy Lambda

  ```
  sls deploy --staging dev
  ```
- In the AWS console, you can confirm that NewRelicPythonXX has been added to the Lambda Layers

## API operation check for lambda

- Call API
  ```
  $ curl https://************.execute-api.ap-northeast-1.amazonaws.com/dev/uuid
  {"uuid":"2b1a2681-e207-4284-9281-efc4a5a408ca"}
  ```

- See CloudWatch Log group

You can confirm to `[NR_EXT] New Relic Lambda Extension starting up`

```
2022-03-02T23:03:47.835+09:00	START RequestId: 100910f0-5471-4c6e-b94e-8fadfbd5bfd6 Version: $LATEST

2022-03-02T23:03:47.972+09:00	[NR_EXT] New Relic Lambda Extension starting up

2022-03-02T23:03:47.973+09:00	[NR_EXT] Starting log server.

2022-03-02T23:03:48.793+09:00	LOGS Name: newrelic-lambda-extension State: Subscribed Types: [platform]

2022-03-02T23:03:48.793+09:00	EXTENSION Name: newrelic-lambda-extension State: Ready Events: [INVOKE,SHUTDOWN]

2022-03-02T23:03:48.838+09:00	END RequestId: 100910f0-5471-4c6e-b94e-8fadfbd5bfd6

2022-03-02T23:03:48.838+09:00	REPORT RequestId: 100910f0-5471-4c6e-b94e-8fadfbd5bfd6 Duration: 44.29 ms Billed Duration: 45 ms Memory Size: 1024 MB Max Memory Used: 98 MB Init Duration: 1038.06 ms
```

