if Meteor.isClient
  Session.setDefault 'counter', 0

  Template.hello.helpers counter: -> Session.get 'counter'

  Template.hello.events {
    'click button': -> Session.set 'counter', 1 + Session.get 'counter'
  }

if Meteor.isServer
  Meteor.startup () ->
    console.log "code to run on server at startup"
