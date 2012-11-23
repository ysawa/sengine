class Push extends Backbone.Model
  defaults:
    _id: null
    content: null
    push_type: null

  get_value: ->
    @get('value')

  idAttribute: "_id"

  initialize: (attributes) ->
    return unless attributes
    @attributes = attributes

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
  observing: null

  notice_offline: ->
    $.notice('offline')

  observe: ->
    @stop()
    @interval = PushObserver.MIN_INTERVAL
    @start()
    null

  observe_process: (recursive) ->
    if navigator.onLine
      result = @fetch()
      switch result.status
        when 0
          @notice_offline() if @online
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
      @notice_offline() if @online
      @online = false
      @notice_offline()
      @interval = PushObserver.MAX_INTERVAL
    if recursive
      @observing = setTimeout(
        =>
          @observe_process(true)
        , @interval # from MIN_INTERVAL to MAX_INTERVAL
      )
    null

  start: ->
    if @observing
      false
    else
      @observe_process(true)
      true

  stop: ->
    if @observing
      clearTimeout(@observing)
      @observing = null
      true
    else
      false

class PushView extends Backbone.View
  tagName: 'li'
  className: 'push'
  el: 'ul#pushes'

  render: ->
    $(@el).html(@template(this.model.toJSON()))
    @

this.Push = Push
this.PushObserver = PushObserver
this.PushView = PushView
