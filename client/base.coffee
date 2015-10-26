#Meteor.subscribe 'userData'

Meteor.startup ->
  Session.set 'example_problem', problem.getRandom()

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
