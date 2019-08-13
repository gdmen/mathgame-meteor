/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Meteor.startup(() => $.getScript('//www.youtube.com/iframe_api'));

const isApiReady = new ReactiveVar(false);
this.onYouTubeIframeAPIReady = () => isApiReady.set(true);

const TEMPLATE_NAME = 'youtube_autoplay';

// Right now only supports one youtube player on the page. It may be possible to
// support multiple youtube players by generating unique PLAYER_DOM_ID values and
// removing the _.memoize from the Template.registerHelper call.
const PLAYER_DOM_ID='youtube_player';
Template.registerHelper(TEMPLATE_NAME, _.memoize(function() {

  // The YouTube API replaces the PLAYER_DOM_ID div with an iframe.  For some
  // reason (didn't investigate) this results in meteor's rendering logic failing
  // to remove the iframe even once the template is deleted from the view.
  // Wrapping it in a second div makes it work.
  const template = Template.fromString(`<div><div id='${PLAYER_DOM_ID}'></div></div>`);

  template.onRendered(function() {

    check(this.data, {
      height: Match.Integer,
      width: Match.Integer,
      mute: Match.Optional(Boolean),
      video: Match.ObjectIncluding({
        videoId: String,
        startSeconds: Match.Integer,
        endSeconds: Match.Integer
      })
    }
    );

    const isReady = new ReactiveVar(false);
    this.autorun(() => {
      if (isReady.get()) {
        if (this.data.mute) {
          this.player.mute();
        }
        return this.player.loadVideoById(this.data.video);
      }
    });
    return this.autorun(() => {
      if (isApiReady.get()) {
        return this.player = new YT.Player(
          PLAYER_DOM_ID,
          {
            height: this.data.height,
            width: this.data.width,
            playerVars: {
              autoplay: true,
              controls: 0,
              modestbranding: 1,
              rel: 0,
              showinfo: 0
            },
            events: {
              onStateChange: (function() {
                const triggerEvent = suffix => $(`#${PLAYER_DOM_ID}`).trigger($.Event(`${TEMPLATE_NAME}_${suffix}`));
                let hasBuffered = false;
                return function(event) {
                  switch (event.data) {
                    case YT.PlayerState.BUFFERING:
                      return hasBuffered = true;
                    case YT.PlayerState.UNSTARTED:
                      if (hasBuffered) { return triggerEvent('failed'); }
                      break;
                    case YT.PlayerState.ENDED:
                      return triggerEvent('ended');
                  }
                };
              })(),
              onReady(event) {
                return isReady.set(true);
              }
            }
          }
        );
      }
    });
  });
  return template;
})
);
