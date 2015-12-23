path     = require 'path'
rootPath = path.normalize __dirname + '/..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'ktabori'
    port: 3000
    api: 'http://cms.dmngd.co/'


  test:
    root: rootPath
    app:
      name: 'ktabori'
    port: 3000
    api: 'http://cms.dmngd.co/'


  production:
    root: rootPath
    app:
      name: 'ktabori'
    port: process.env.PORT || 3000
    api: 'http://cms.dmngd.co/'

module.exports = config[env]
