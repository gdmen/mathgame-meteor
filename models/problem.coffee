silly = {
  id: "silly_can_you_enter_the_number_42"
  question: "Can you enter the number 42?"
  answer: 42
}

@problem = {
  get: (id) ->
    check(id, String)
    if id is silly.id
      silly
    else
      null
  getRandom: -> silly
}
