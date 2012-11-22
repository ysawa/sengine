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

  notice_offline: ->
    $.notice('offline')

  observe: ->
    @observe_process(true)
    null

  observe_process: (recursive) ->
    if navigator.onLine
      result = @fetch()
      switch result.status
        when 0
          @notice_offline() unless @online
          @online = false
          @interval = PushObserver.MAX_INTERVAL
        when 200
          @online = true
          @interval = PushObserver.MIN_INTERVAL
        else
          @online = true
          @interval *= 2
          if @interval > PushObserver.MAX_INTERVAL
            @interval = PushObserver.MAX_INTERVAL
    else
      @notice_offline() unless @online
      @online = false
      @notice_offline()
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
