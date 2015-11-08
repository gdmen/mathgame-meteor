VIDEOS = [
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 1' }
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 1' }
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 2' }
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 2' }
  { videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 25, title: 'Contact Juggling 3' }
  { videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25, title: 'Broken Video 3' }
]

class @ProblemFlow

  constructor: (spec) ->

    check spec.numToSolve, Match.Integer
    @numToSolve = spec.numToSolve

    @_videoOptions = new ReactiveVar()
    @_lastVideoFailed = new ReactiveVar false
    @_video = new ReactiveVar()
    @_numSolved = new ReactiveVar 0
    @_currentProblem = new ReactiveVar @getNextProblem()

  getNextProblem: ->
    problem.getRandom ADDITION, x: [1, 10], y: [1, 10]

  setVideoOptions: ->
    @_videoOptions.set _.sample VIDEOS, 3

  onProblemAnswered: (event) ->
    if event.isCorrect
      @_numSolved.set @_numSolved.get() + 1
      if @_numSolved.get() is @numToSolve
        @_currentProblem.set undefined
        @setVideoOptions()
      else
        @_currentProblem.set @getNextProblem()

  onClickVideoOption: (video) ->
    @_videoOptions.set undefined
    @_video.set video

  onYoutubeAutoplayEnded: ->
    @_lastVideoFailed.set false
    @_video.set undefined
    @_numSolved.set 0
    @_currentProblem.set @getNextProblem()

  onYoutubeAutoplayFailed: ->
    failedVideo = @_video.get()
    VIDEOS = _.filter VIDEOS, (v) -> v isnt failedVideo
    @_lastVideoFailed.set true
    @_video.set undefined
    @setVideoOptions()

Template.problem_flow_view.helpers

  # TODO - there has to be a better way to do this for reactive vars
  currentProblem: -> @_currentProblem.get()
  videoOptions: -> @_videoOptions.get()
  lastVideoFailed: -> @_lastVideoFailed.get()
  video: -> @_video.get()

Template.problem_flow_view_progress_bar.helpers

  percentSolved: -> Math.round @_numSolved.get() / @numToSolve * 100

Template.problem_flow_view.events

  problem_answered: (event, template) -> template.data.onProblemAnswered(event)

  'click .videoOption': (event, template) ->
    template.data.onClickVideoOption @

  youtube_autoplay_ended: (event, template) -> template.data.onYoutubeAutoplayEnded()

  youtube_autoplay_failed: (event, template) -> template.data.onYoutubeAutoplayFailed()
