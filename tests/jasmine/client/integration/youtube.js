/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
describe('the youtube module', function() {

  let view = undefined;

  afterEach(function() {
    if (view) { return Blaze.remove(view); }
  });

  const assertEventIsTriggered = function(videoId, eventName, done) {
    const template = UI._globalHelpers.youtube_autoplay();
    template.events({[eventName]: done});
    const data = {
      width: 640,
      height: 390,
      mute: true,
      video: {
        videoId,
        startSeconds: 5,
        endSeconds: 6
      }
    };
    return view = Blaze.renderWithData(template, data, document.body);
  };

  const it = function(title, spec) { return this.it(title, spec, 10000); }; // increase the async test timeout

  it('triggers the "failed" event for a "terminated account" video', done => assertEventIsTriggered('ktk-YFw0hIA', 'youtube_autoplay_failed', done));

  it('triggers the "ended" event after playing a video', done => assertEventIsTriggered('0rqeR-iLKYA', 'youtube_autoplay_ended', done));

  return it('triggers the "failed" event for a "commercially deceptive" video', done => assertEventIsTriggered('yh9NdWbWj-g', 'youtube_autoplay_failed', done));
});
