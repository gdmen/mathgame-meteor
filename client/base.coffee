Meteor.subscribe 'userData'

currentProblemFlow = new ReactiveVar()

Meteor.startup ->
  currentProblemFlow.set new ProblemFlow numToSolve: 3

Template.body.helpers

  flow: -> currentProblemFlow.get()

Template.body.events

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle()
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout()
    return
