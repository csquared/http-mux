http      = require('http')
httpProxy = require('http-proxy')
fs        = require('fs')

FORWARD_TARGETS_JSON = './forward-targets.json'

targets = []
# get forward targets from ENV with FORWARD_TARGET_URL
for key, value of process.env when /TARGET_URL/.test(key)
  tokens = value.split(':')
  host = tokens[0]
  port = tokens[1] || 80
  targets.push(host: host, port: port)
# get forward targets from json file
if fs.existsSync(FORWARD_TARGETS_JSON)
  targets.push(target) for target in JSON.parse(fs.readFileSync(FORWARD_TARGETS_JSON))

if !targets.empty?
  target_list = targets.map((address) -> "#{address.host}:#{address.port}").join(',')
  console.log "Forwarding to: #{target_list}"
  ok_string = JSON.stringify(target_list)

  server = httpProxy.createServer (req, res, proxy) ->
    # return responses to our stdout
    _write     = res.write
    res.write  = (data) -> console.log('res-write', data.toString())
    res.setHeader = (key, value) -> console.log('res-setHeader', key, value)
    for target in targets
      req.headers.host = target.host
      proxy.proxyRequest(req, res, target)
    _write.call(res,ok_string)
    res.end()

port = process.env.PORT || 3000
server.listen(port)

console.log "Proxy up on port #{port}"
