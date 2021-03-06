{CompositeDisposable} = require 'atom'

{views} = require '../ui'
{client} = require '../connection'

workspace = client.import 'workspace'

module.exports =
  activate: ->
    @create()

    client.onDetached =>
      @ws.setItems []

  update: ->
    return @ws.setItems [] unless client.isActive()
    p = workspace('Main').then (ws) =>
      for {items} in ws
        for item in items
          item.value = views.render item.value
      @ws.setItems ws
    p.catch (err) ->
      if err isnt 'disconnected'
        console.error 'Error refreshing workspace'
        console.error err

  create: ->
    @ws = @ink.Workspace.fromId 'julia'

  open: -> @ws.open split: 'right'
