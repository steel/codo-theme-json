Theme = require './_theme'
_ = require "lodash"

module.exports = class Theme.TreeBuilder

  @build: (collection, resolver) ->
    (new @ collection, resolver).tree

  constructor: (@collection, @resolver) ->
    @tree = []

    for entry in @collection
      do (entry) =>
        storage      = @tree
        [name, path] = @resolver(entry)

        for segment in path when segment.length > 0
          storage = @situate(storage, segment)

        @situate(storage, name, entry)


  situate: (storage, name, entity) ->
    for entry in storage
      if entry.name == name
        entry.entity = entry.entity || entity
        return entry.children

    entry =
      name: name
      children: []

    entry.file = entity.file?.path if entity?

    storage.push entry

    entry.children
