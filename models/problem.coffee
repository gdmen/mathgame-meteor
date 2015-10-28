Problems = new Mongo.Collection(
  'mathgame_models_problems',
  transform: (doc) ->
    check doc._id, String
    expr = doc._id
    questionObject = math.parse expr
    answerObject = math.eval expr
    _.extend doc,
      question: "What is #{questionObject.toString()} ?"
      answer: answerObject.toFraction()
)

problemTypeMap = {
  ADDITION: (config) ->
    check config.min1, Match.Integer
    check config.max1, Match.Integer
    check config.min2, Match.Integer
    check config.max2, Match.Integer
    num1 = _.random config.min1, config.max1
    num2 = _.random config.min2, config.max2
    "#{num1} + #{num2}"
}

Problems.attachSchema new SimpleSchema {
  type: {
    type: String
    label: 'type'
    allowedValues: _.keys problemTypeMap
  }
}

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

  getRandom: (problemType, config) ->
    check problemType, Match.Where (k) -> problemTypeMap[k]?
    _id = problemTypeMap[problemType](config)
    if not @get _id
      Problems.insert {_id, type: problemType}
    @get _id

for problemType in _.keys problemTypeMap
  @problem[problemType] = problemType

