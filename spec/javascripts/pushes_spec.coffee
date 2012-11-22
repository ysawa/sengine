describe 'Push', ->
  model = null

  beforeEach ->
    # each test
    model = new Push()

  it 'has null values at the first time', ->
    expect(model.get('_id')).toEqual(null)
    expect(model.get('content')).toEqual(null)
