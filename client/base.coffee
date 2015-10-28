Meteor.subscribe 'userData'

@exampleProblem = new ReactiveVar()

Meteor.startup ->
  exampleProblem.set problem.getRandom MULTIPLICATION,
    x: [1, 100]
    y: [1, 100]

Template.body.helpers

  problem: -> exampleProblem.get()

Template.body.events

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle()
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout()
    return
