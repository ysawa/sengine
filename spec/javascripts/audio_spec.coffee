describe '$.audio', ->

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

    describe 'if audio feature is NOT enabled', ->
      beforeEach ->
        $.audio.enabled = false

      it 'does not try to initialize audio data', ->
        $.audio.initialize('sound1')
        expect($.audio.schemes['sound1']).toBeUndefined()

  describe '.play', ->
    describe 'if audio feature is enabled', ->
      beforeEach ->
        $.audio.enabled = true

      describe 'if <audio> tag is supported', ->
        put_audio_path = '/assets/images/audio/put.mp3'
        beforeEach ->
          $.audio.tag_support = true
          $.audio.schemes = { put: put_audio_path }
        afterEach ->
          $.audio.tag_support = !!(document.createElement('audio').canPlayType)
          $.audio.schemes = {}
        it 'tries to play audio without errors', ->
          $.audio.play('put')

      describe 'if <audio> tag is NOT supported and browser is msie', ->
        beforeEach ->
          $.audio.tag_support = false
          $.browser.msie = true
        afterEach ->
          $.audio.tag_support = !!(document.createElement('audio').canPlayType)
          $.browser.msie = false
        it 'tries to play audio with <bgsound>', ->
          $.audio.play('put')
          bgsound = $('bgsound')
          expect(bgsound.size()).toBe(1)
          expect(bgsound.attr('src')).toMatch(/put\.wav$/)

    describe 'if audio feature is NOT enabled', ->
      beforeEach ->
        $.audio.enabled = false
      it 'is processed without errors and nothing occurs', ->
        # test cannot be implemented correctly
        $.audio.play('put')
