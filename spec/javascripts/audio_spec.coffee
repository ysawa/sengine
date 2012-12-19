describe '$.audio', ->
  model = null

  beforeEach ->
    model = true

  describe '.enable', ->
    it 'enables audio feature', ->
      $.audio.enable()
      expect($.audio.enabled).toBe(true)

  describe '.disable', ->
    it 'disables audio feature', ->
      $.audio.disable()
      expect($.audio.enabled).toBe(false)

  describe '.tag_support', ->
    it 'has a boolean value to see if <audio> tag is supported', ->
      bool = $.audio.tag_support
      expect(bool).toBe(true)

  describe '.find_enabled_format', ->
    it 'finds enabled format', ->
      format = $.audio.find_enabled_format()
      expect(format).toNotEqual(null)
      expect(format).toMatch(/\.(mp3|ogg|wav)/)

  describe '.initialize', ->
    describe 'if audio feature is enabled', ->
      beforeEach ->
        $.audio.enabled = true

      it 'tries to initialize audio data', ->
        $.audio.initialize('sound0')
        expect($.audio.schemes['sound0']).toBeDefined()

    describe 'if audio feature is enabled', ->
      beforeEach ->
        $.audio.enabled = false

      it 'does not try to initialize audio data', ->
        $.audio.initialize('sound1')
        expect($.audio.schemes['sound1']).toBeUndefined()

