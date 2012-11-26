describe 'Push', ->
  model = null

  beforeEach ->
    model = new Push({ content: 'Content Text' })

  it 'has null values at the first time', ->
    expect(model.get('_id')).toEqual(null)
    expect(model.get('content')).toEqual('Content Text')

  describe '.toJSON', ->
    it 'generates hash in order to send to the server', ->
      hash = model.toJSON()
      expect(hash['push']['content']).toEqual('Content Text')

    it 'hides _type', ->
      model.set('_type', 'InvalidType')
      hash = model.toJSON()
      expect(hash['push']['_type']).toEqual(null)

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

  describe '.notice_all', ->
    beforeEach ->
      # initialize html
      $('body #pushes').remove()
      $('body').append($('<div>').attr(id: 'pushes'))

    it 'notices all pushes', ->
      expect(observer.models).toEqual([])
      observer.models.push(new Push(content: 'Content Text 1'))
      observer.models.push(new Push(content: 'Content Text 2'))
      observer.notice_all()
      expect(observer.models.length).toEqual(2)
      expect($('#pushes li').size()).toEqual(2)
      expect($('#pushes li:first-child').text()).toMatch('Content Text 1')
      expect($('#pushes li:last-child').text()).toMatch('Content Text 2')

describe 'PushView', ->
  view = null
  model = null

  beforeEach ->
    model = new Push(content: 'Content Text')
    view = new PushView(model: model)
    # initialize html
    $('body #pushes').remove()
    $('body').append($('<div>').attr(id: 'pushes'))

  describe '.template', ->
    it 'renders content text', ->
      expect(view.template(model.attributes)).toMatch('Content')

    it 'renders content text with a tag', ->
      expect(view.template(model.attributes)).toNotMatch('<a href')
      model.set('href', 'http://example.com')
      expect(view.template(model.attributes)).toMatch('<a href')

  describe '.add', ->
    it 'renders content element into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      expect($('#pushes').html()).toMatch('Content Text')

    it 'renders content element with unique id into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      unique_model = new Push(content: 'Content Text')
      unique_view = new PushView(model: unique_model, id: 'unique-push')
      unique_view.add()
      expect($('#pushes li').size()).toEqual(2)
      expect($('#pushes').html()).toMatch('id="unique-push"')

  describe '.remove', ->
    it 'deletes content element into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      view.remove()
      expect($('#pushes').html()).toEqual('')

    it 'deletes content element with unique id into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      unique_view = new PushView(model: model, id: 'unique-push')
      unique_view.add()
      expect($('#pushes li').size()).toEqual(2)
      view.remove()
      expect($('#pushes li').size()).toEqual(1)
      expect($('#pushes').html()).toMatch('id="unique-push"')
      view.add()
      unique_view.remove()
      expect($('#pushes li').size()).toEqual(1)
      expect($('#pushes').html()).toNotMatch('id="unique-push"')

    it 'deletes only the element with the same content into #pushes', ->
      expect($('#pushes').html()).toEqual('')
      view.add()
      same_view = new PushView(model: model)
      same_view.add()
      expect($('#pushes li').size()).toEqual(2)
      same_view.remove()
      expect($('#pushes li').size()).toEqual(1)
      expect($('#pushes').html()).toMatch('Content Text')
