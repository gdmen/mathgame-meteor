Meteor.subscribe 'userData'

currentProblem = new ReactiveVar()
video = new ReactiveVar()

advanceProblem = ->
  currentProblem.set problem.getRandom ADDITION, x: [1, 10], y: [1, 10]

Meteor.startup advanceProblem

Template.body.helpers

  problem: -> currentProblem.get()

  video: -> video.get()

Template.body.events

  'click .play_youtube': ->
    video.set videoId: '0rqeR-iLKYA', startSeconds: 20, endSeconds: 40

  'click .play_unavailable_youtube': ->
    video.set videoId: 'yh9NdWbWj-g', startSeconds: 20, endSeconds: 25

  'youtube_autoplay_ended': ->
    video.set undefined

  'youtube_autoplay_failed': ->
    video.set undefined
    alert "Failed to play the video!"

  'problem_answered': (event) ->
    advanceProblem() if event.isCorrect

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle()
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout()
    return
