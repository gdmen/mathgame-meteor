Meteor.subscribe 'userData'

Meteor.startup ->
  Session.set 'example_problem', problem.getRandom problem.ADDITION, {
    min1: 1
    max1: 100
    min2: 1
    max2: 100
  }

Template.body.helpers

  problem: -> Session.get 'example_problem'

Template.body.events

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle()
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout()
    return
