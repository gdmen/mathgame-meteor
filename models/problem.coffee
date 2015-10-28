Problems = new Mongo.Collection(
  'mathgame_models_problems',
  transform: (doc) ->
    check doc._id, String
    expr = doc._id
    questionObject = math.parse expr
    answerObject = math.eval expr
    _.extend doc,
      question: "What is #{
        questionObject
          .toString()
          .replace(/\*/g, '\u00D7')
          .replace(/\//g, '\u00F7')
      } ?"
      questionLatex: "\\text{What is }#{
        questionObject
          .toTex()
          .replace(/\\cdot/g, '\\times')
      }\\text{ ?}"
      answer: answerObject.toFraction()
      answerLatex: answerObject.toLatex()
)

getRandomValue = (range) ->
  check range, [Match.Integer]
  check range.length, 2
  check range[0] <= range[1], true
  _.random range[0], range[1]

problemTypeMap =

  ADDITION: (config) ->
    "#{getRandomValue config.x} + #{getRandomValue config.y}"

  MULTIPLICATION: (config) ->
    "#{getRandomValue config.x} * #{getRandomValue config.y}"

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
  @[problemType] = problemType

