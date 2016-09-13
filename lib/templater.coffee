FS      = require 'fs'
Path    = require 'path'
mkdirp  = require 'mkdirp'
_       = require 'lodash'
Theme   = require './_theme'
Util    = require 'util'

module.exports = class Theme.Templater
  constructor: (@destination) ->

  classJSON: (entity) ->
    obj = entity.inspect()
    obj["methods"] =
      static: entity.effectiveMethods().filter (m) -> m.kind == 'static' && m.visible
      instance: entity.effectiveMethods().filter (m) -> m.kind == 'dynamic' && m.name != 'constructor' && m.visible
      constructor: entity.effectiveMethods().filter (m) -> m.kind == 'dynamic' && m.name == 'constructor'

    JSON.stringify(obj, null, "\t")

  mixinJSON: (entity) ->
    obj = entity.inspect()

    JSON.stringify(obj, null, "\t")

  extraJSON: (entity) ->
    obj = entity.inspect()

    JSON.stringify(obj, null, "\t")

  indexJSON: (tree) ->
    replacer = (key, val) ->
      if key == "children" && val.length == 0
        undefined
      else
        val

    JSON.stringify(tree, replacer, "\t")

  # @param [String] template the template name
  # @param [Object] context the context object
  # @param [String] filename the output file name
  #
  render: (template, context = {}, filename = '') ->
    json = @["#{template}JSON"](context.entity)

    if filename.length > 0
      file = Path.join @destination, filename
      dir  = Path.dirname(file)

      mkdirp.sync(dir)
      FS.writeFileSync(file, json)
