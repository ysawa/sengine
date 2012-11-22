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
      expect(navigator.onLine).toEqual(false)
      observer.observe_process(false)
      expect(observer.interval).toEqual(32000)
