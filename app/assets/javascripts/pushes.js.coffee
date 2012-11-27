class Push extends Backbone.Model
  defaults:
    _id: null
    content: null
    pushable: null
    push_type: null

  get_content: ->
    @get('content')

  get_push_type: ->
    @get('push_type')

  idAttribute: "_id"

  initialize: (attributes) ->
    return unless attributes
    @attributes = attributes

  toJSON: ->
    attributes = _.clone(@attributes)
    delete attributes['_type']
    {
      push: attributes
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

  notice_all: ->
    @each (push) ->
      view = new PushView(model: push)
      view.add(true)

  notice_offline: ->
    $.notice('offline')

  notice_push: (push) ->
    push.notice()

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
          @notice_all_pushes()
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

  add: (bottom = true) ->
    if bottom
      $('#pushes').append($(@el))
    else
      $('#pushes').prepend($(@el))
    @render()

  delete: ->
    $(@el).remove()

  render: ->
    $(@el).html(@template(this.model.attributes))
    @

  template: (attributes) ->
    format = """
             <% if (typeof href !== 'undefined' && href) { %>
               <a href=<%= href %>><%= content %></a>
             <% } else { %>
               <span><%= content %></span>
             <% } %>
             """
    compiled = _.template(format)
    compiled(attributes)

this.Push = Push
this.PushObserver = PushObserver
this.PushView = PushView
