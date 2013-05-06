# http-mux

Easily configurable HTTP Forwarding proxy for forwarding to multiple endpoints.

## Use

Set ENV vars with `TARGET_URL` such as:

    GOOGLE_TARGET_URL=google.com
    LOCALHOST_TARGET_URL=localhost:3456


And/or create a `forward-targets.json` such as:

```javascript
[
  {
    "host" : "localhost",
    "port" : 3333
  }
]

```

Then run with

    > PORT=3000 ./bin/web
    Forwarding to: google.com:80,localhost:3456,localhost:3333
    Proxy up on port 3000

and you're off!

Send requests via:

    curl http://localhost:3000/

