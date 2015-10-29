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
    isReady = new ReactiveVar false
    @autorun =>
      if isReady.get()
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
              onStateChange: (event) ->
                if event.data == YT.PlayerState.ENDED
                  $("##{PLAYER_DOM_ID}").trigger $.Event "#{TEMPLATE_NAME}_ended"
              onReady: (event) ->
                isReady.set true
          }
        )
  template
