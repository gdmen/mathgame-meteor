Problems = new Mongo.Collection(
  'mathgame_models_problems',
  transform: (doc) ->
    check doc._id, String
    expr = doc._id
    questionObject = math.parse expr
    answerObject = math.eval expr

    _id: doc._id
    question: "What is #{questionObject.toString()} ?"
    answer: answerObject.toFraction()
)

Problems.attachSchema new SimpleSchema {}

if Meteor.isServer
  Problems.allow insert: -> true
  Meteor.publish 'mathgame_models_problems.all', -> Problems.find {}
if Meteor.isClient
  Meteor.subscribe 'mathgame_models_problems.all'

@problem =

  _c: Problems

  get: (_id) ->
    check _id, String
    Problems.findOne {_id}

  getRandom: ->
    _id = "#{_.random(1, 100)} + #{_.random(1, 100)}"
    if not @get _id
      Problems.insert {_id}
    @get _id
