Problems = new Mongo.Collection null

fromExpression = (expr) ->
  check expr, String

  questionObject = math.parse expr
  answerObject = math.eval expr

  _id = questionObject.toString()
  if not Problems.findOne {_id}
    Problems.insert
      _id: _id
      questionText: "What is #{questionObject.toString()} ?"
      questionLatex: "What is #{questionObject.toTex()} ?"
      answerText: answerObject.toFraction()
      answerLatex: answerObject.toLatex()
  Problems.findOne {_id}

@problem =

  _c: Problems

  get: (_id) ->
    check _id, String
    Problems.findOne {_id}

  getRandom: ->
    fromExpression "#{_.random(1, 100)} + #{_.random(1, 100)}"
