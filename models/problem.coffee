Problems = new Mongo.Collection null

fromExpression = (expr) ->
  check expr, String
  _id = math.parse(expr).toString()
  if not Problems.findOne {_id}
    Problems.insert
      _id: _id
      question: "What is #{expr} ?"
      answer: math.eval expr
  Problems.findOne {_id}

@problem =

  _c: Problems

  get: (_id) ->
    check _id, String
    Problems.findOne {_id}

  getRandom: ->
    fromExpression "#{_.random(1, 100)} + #{_.random(1, 100)}"
