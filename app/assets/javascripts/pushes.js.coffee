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
  interval: 2000
  model: Push
  online: true

  observe: ->
    setTimeout(
      ->
        null
      , @interval
    )
    null

this.Push = Push
this.PushObserver = PushObserver
