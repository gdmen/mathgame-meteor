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

@problem =

  _c: Problems

  get: (_id) ->
    check _id, String
    Problems.findOne {_id}

  getRandom: ->
    _id = "#{_.random(1, 100)} + #{_.random(1, 100)}"
    Problems.upsert {_id}, {_id}
    @get _id
