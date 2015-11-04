describe 'the problem module', ->

  it 'returns a trivial addition problem', ->
    config = x: [1, 1], y: [2, 2]
    expect(problem.getRandom ADDITION, config).toEqual
      _id: '1 + 2'
      type: ADDITION
      question: '1 + 2'
      questionLatex: '1+2'
      answer: '3'
      answerLatex: '3'

  it 'returns a trivial multiplication problem', ->
    config = x: [6, 6], y: [7, 7]
    expect(problem.getRandom MULTIPLICATION, config).toEqual
      _id: '6 * 7'
      type: MULTIPLICATION
      question: '6 \u00D7 7'
      questionLatex: '6\\times7'
      answer: '42'
      answerLatex: '42'

  it 'returns trivial subtraction and division problems', ->

    expect(problem.getRandom(
      DIVISION,
      y: [7, 7], z: [6, 6]
    )).toEqual
      _id: '42 / 7'
      type: DIVISION
      question: '42 \u00F7 7'
      questionLatex: '42\\div7'
      answer: '6'
      answerLatex: '6'

    expect(problem.getRandom(
      SUBTRACTION,
      y: [7, 7], z: [35, 35]
    )).toEqual
      _id: '42 - 7'
      type: SUBTRACTION
      question: '42 - 7'
      questionLatex: '42-7'
      answer: '35'
      answerLatex: '35'
