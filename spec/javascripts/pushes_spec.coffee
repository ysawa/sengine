describe 'Push', ->
  model = null

  beforeEach ->
    model = new Push()

  it 'has null values at the first time', ->
    expect(model.get('_id')).toEqual(null)
    expect(model.get('content')).toEqual(null)

describe 'PushObserver', ->
  observer = null

  beforeEach ->
    observer = new PushObserver()

  it 'has 2 secs interval at the first time', ->
    expect(observer.interval).toEqual(2000)

  describe '.observe_process', ->
    it 'changes the interval 32000 if offline (without recursion)', ->
      expect(observer.models).toEqual([])
      expect(navigator.onLine).toEqual(false)
      observer.observe_process(false)
      expect(observer.interval).toEqual(32000)
      expect(observer.models).toEqual([])

    it 'changes the online false if offline (without recursion)', ->
      expect(observer.online).toEqual(true)
      expect(navigator.onLine).toEqual(false)
      observer.observe_process(false)
      expect(observer.online).toEqual(false)

  describe '.start', ->
    it 'start observing', ->
      expect(observer.observing).toEqual(null)
      expect(observer.start()).toEqual(true)
      expect(observer.observing).toNotEqual(null)

    it 'cannot start observing if already observing', ->
      expect(observer.observing).toEqual(null)
      observer.start()
      expect(observer.observing).toNotEqual(null)
      expect(observer.start()).toEqual(false)

  describe '.stop', ->
    it 'stop observing', ->
      expect(observer.observing).toEqual(null)
      observer.start()
      expect(observer.observing).toNotEqual(null)
      expect(observer.stop()).toEqual(true)
      expect(observer.observing).toEqual(null)

    it 'cannot stop observing if not observing', ->
      expect(observer.observing).toEqual(null)
      expect(observer.stop()).toEqual(false)

  describe '.observe', ->
    it 'start observing', ->
      expect(observer.observing).toEqual(null)
      observer.observe()
      expect(observer.observing).toNotEqual(null)
    it 'stop the past observing', ->
      observer.start()
      past_observing = observer.observing
      expect(past_observing).toNotEqual(null)
      observer.observe()
      expect(observer.observing).toNotEqual(past_observing)

describe 'PushView', ->
  view = null
  model = null

  beforeEach ->
    model = new Push(content: 'Content Text')
    view = new PushView(model: model)
    $('body #pushes').remove()
    $('body').append($('<div>').attr(id: 'pushes'))

  describe '.template', ->
    it 'render content text', ->
      expect(view.template(model.attributes)).toMatch('Content')

  describe '.add', ->
    it 'render content element into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      expect($('#pushes').html()).toMatch('Content Text')

  describe '.remove', ->
    it 'render content element into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      view.remove()
      expect($('#pushes').html()).toEqual('')
