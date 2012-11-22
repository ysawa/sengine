class Push extends Backbone.Model
  defaults:
    _id: null
    content: null

  get_value: ->
    @get('value')

  idAttribute: "_id"

  toJSON: ->
    {
      push: _.clone(@attributes)
    }

  urlRoot: ->
    "/pushes"

class PushObserver extends Backbone.Collection
  @MAX_INTERVAL: 32000
  @MIN_INTERVAL: 2000
  interval: 2000
  model: Push
  online: true
  url: '/pushes'

  observe: ->
    @observe_process(true)
    null

  observe_process: (recursive) ->
    if navigator.onLine
      @online = true
      result = @fetch()
      switch result.status
        when 0
          @online = false
          @interval = PushObserver.MAX_INTERVAL
        when 200
          @interval = PushObserver.MIN_INTERVAL
        else
          @interval *= 2
          if @interval > PushObserver.MAX_INTERVAL
            @interval = PushObserver.MAX_INTERVAL
    else
      @online = false
      @interval = PushObserver.MAX_INTERVAL
    if recursive
      setTimeout(
        =>
          @observe_process(true)
        , @interval # from MIN_INTERVAL to MAX_INTERVAL
      )
    null

this.Push = Push
this.PushObserver = PushObserver
