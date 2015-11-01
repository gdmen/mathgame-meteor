describe 'the youtube module', ->

  view = undefined

  afterEach ->
    Blaze.remove view if view

  assertEventIsTriggered = (videoId, eventName, done) ->
    template = UI._globalHelpers.youtube_autoplay()
    template.events "#{eventName}": done
    data =
      width: 640
      height: 390
      mute: true
      video:
        videoId: videoId
        startSeconds: 5
        endSeconds: 6
    view = Blaze.renderWithData template, data, document.body

  it = (title, spec) -> @it title, spec, 10000 # increase the async test timeout

  it 'triggers the "failed" event for a "terminated account" video', (done) ->
    assertEventIsTriggered 'ktk-YFw0hIA', 'youtube_autoplay_failed', done

  it 'triggers the "ended" event after playing a video', (done) ->
    assertEventIsTriggered '0rqeR-iLKYA', 'youtube_autoplay_ended', done

  it 'triggers the "failed" event for a "commercially deceptive" video', (done) ->
    assertEventIsTriggered 'yh9NdWbWj-g', 'youtube_autoplay_failed', done
