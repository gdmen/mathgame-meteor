Problems = new Mongo.Collection(
  null,
  transform: (doc) ->
    check doc._id, String
    expr = doc._id
    questionObject = math.parse expr
    answerObject = math.eval expr

    _id: doc._id
    question: "What is #{questionObject.toString()} ?"
    answer: answerObject.toFraction()
)

Problems.attachSchema new SimpleSchema {
  originalExpression:
    type: String
    label: "The original expression that was used to create the problem."
    max: 20
}

normalizeExpression = (expr) ->
  math.parse(expr).toString()

@problem =

  _c: Problems

  get: (_id) ->
    check _id, String
    Problems.findOne {_id}

  getRandom: ->
    originalExpression = "#{_.random(1, 100)} + #{_.random(1, 100)}"
    _id = normalizeExpression originalExpression
    Problems.upsert {_id}, $set: {originalExpression}
    @get _id
