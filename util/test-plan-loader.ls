require! npm
module.exports = loader =
  LOCAL: 'driven-test-plans'
  load: ({test-package, package-name, test-name}, callback)->
    return callback! if test-package is loader.LOCAL  or not test-package # 驱动开发时，执行本地驱动用例。
    npm.load (err)->
      throw err if err?
      npm.commands.install [test-package], (err, data)->
        throw err if err
        callback require package-name + '/' + test-name
      npm.on 'log', console.log
