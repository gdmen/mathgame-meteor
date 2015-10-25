if Meteor.isClient
  Session.setDefault 'counter', 0

if Meteor.isServer
  Meteor.startup () ->
    console.log "code to run on server at startup"
