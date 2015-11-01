Meteor.startup -> $.getScript '//www.youtube.com/iframe_api'

isApiReady = new ReactiveVar false
@onYouTubeIframeAPIReady = -> isApiReady.set true

TEMPLATE_NAME = 'youtube_autoplay'

# Right now only supports one youtube player on the page. It may be possible to
# support multiple youtube players by generating unique PLAYER_DOM_ID values and
# removing the _.memoize from the Template.registerHelper call.
PLAYER_DOM_ID='youtube_player'
Template.registerHelper TEMPLATE_NAME, _.memoize ->

  # The YouTube API replaces the PLAYER_DOM_ID div with an iframe.  For some
  # reason (didn't investigate) this results in meteor's rendering logic failing
  # to remove the iframe even once the template is deleted from the view.
  # Wrapping it in a second div makes it work.
  template = Template.fromString "<div><div id='#{PLAYER_DOM_ID}'></div></div>"

  template.onRendered ->

    check @data,
      height: Match.Integer
      width: Match.Integer
      mute: Match.Optional Boolean
      video:
        videoId: String
        startSeconds: Match.Integer
        endSeconds: Match.Integer

    isReady = new ReactiveVar false
    @autorun =>
      if isReady.get()
        if @data.mute
          @player.mute()
        @player.loadVideoById @data.video
    @autorun =>
      if isApiReady.get()
        @player = new YT.Player(
          PLAYER_DOM_ID,
          {
            height: @data.height
            width: @data.width
            playerVars:
              autoplay: true
              controls: 0
              modestbranding: 1
              rel: 0
              showinfo: 0
            events:
              onStateChange: do ->
                triggerEvent = (suffix) ->
                  $("##{PLAYER_DOM_ID}").trigger $.Event "#{TEMPLATE_NAME}_#{suffix}"
                hasBuffered = false
                (event) ->
                  switch event.data
                    when YT.PlayerState.BUFFERING
                      hasBuffered = true
                    when YT.PlayerState.UNSTARTED
                      triggerEvent 'failed' if hasBuffered
                    when YT.PlayerState.ENDED
                      triggerEvent 'ended'
              onReady: (event) ->
                isReady.set true
          }
        )
  template
