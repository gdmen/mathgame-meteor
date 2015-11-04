Template.problem_view.onCreated ->
  @lastAnswer = new ReactiveVar answer: 'n/a', isCorrect: true, isWrong: false

Template.problem_view.onRendered ->
  @$('input').focus()

Template.problem_view.helpers

  lastAnswer: -> Template.instance().lastAnswer.get()

Template.problem_view.events

  submit: (event) ->

    target = $ event.target
    input = $ event.target.answer
    answer = input.val().trim()

    if answer.length is 0
      input.val ''
    else
      isCorrect = answer is @answer
      data = {answer, isCorrect, isWrong: not isCorrect}
      target.trigger $.Event 'problem_answered', data
      Template.instance().lastAnswer.set data
      input.val '' if isCorrect

    input.focus()
    false
