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
