/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let VIDEOS = [
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 1' },
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 1' },
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 2' },
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 2' },
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 3' },
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 3' }
];

this.ProblemFlow = class ProblemFlow {

  constructor(spec) {

    check(spec.numToSolve, Match.Integer);
    this.numToSolve = spec.numToSolve;

    this._videoOptions = new ReactiveVar();
    this._lastVideoFailed = new ReactiveVar(false);
    this._video = new ReactiveVar();
    this._numSolved = new ReactiveVar(0);
    this._currentProblem = new ReactiveVar(this.getNextProblem());
  }

  getNextProblem() {
    return problem.getRandom(ADDITION, {x: [1, 10], y: [1, 10]});
  }

  setVideoOptions() {
    return this._videoOptions.set(_.sample(VIDEOS, 3));
  }

  onProblemAnswered(event) {
    if (event.isCorrect) {
      this._numSolved.set(this._numSolved.get() + 1);
      if (this._numSolved.get() === this.numToSolve) {
        this._currentProblem.set(undefined);
        return this.setVideoOptions();
      } else {
        return this._currentProblem.set(this.getNextProblem());
      }
    }
  }

  onClickVideoOption(video) {
    this._videoOptions.set(undefined);
    return this._video.set(video);
  }

  onYoutubeAutoplayEnded() {
    this._lastVideoFailed.set(false);
    this._video.set(undefined);
    this._numSolved.set(0);
    return this._currentProblem.set(this.getNextProblem());
  }

  onYoutubeAutoplayFailed() {
    const failedVideo = this._video.get();
    VIDEOS = _.filter(VIDEOS, v => v !== failedVideo);
    this._lastVideoFailed.set(true);
    this._video.set(undefined);
    return this.setVideoOptions();
  }
};

Template.problem_flow_view.helpers({

  // TODO - there has to be a better way to do this for reactive vars
  currentProblem() { return this._currentProblem.get(); },
  videoOptions() { return this._videoOptions.get(); },
  lastVideoFailed() { return this._lastVideoFailed.get(); },
  video() { return this._video.get(); }
});

Template.problem_flow_view_progress_bar.helpers({

  percentSolved() { return Math.round((this._numSolved.get() / this.numToSolve) * 100); }});

Template.problem_flow_view.events({

  problem_answered(event, template) { return template.data.onProblemAnswered(event); },

  'click .videoOption'(event, template) {
    return template.data.onClickVideoOption(this);
  },

  youtube_autoplay_ended(event, template) { return template.data.onYoutubeAutoplayEnded(); },

  youtube_autoplay_failed(event, template) { return template.data.onYoutubeAutoplayFailed(); }
});
