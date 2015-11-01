Meteor.subscribe 'userData'

video = new ReactiveVar()

Template.body.helpers

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

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle()
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout()
    return
