/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Template.problem_view.onCreated(function() {
  return this.lastAnswer = new ReactiveVar({answer: 'n/a', isCorrect: true, isWrong: false});
});

Template.problem_view.onRendered(function() {
  return this.$('input').focus();
});

Template.problem_view.helpers({

  lastAnswer() { return Template.instance().lastAnswer.get(); }});

Template.problem_view.events({

  submit(event) {

    const target = $(event.target);
    const input = $(event.target.answer);
    const answer = input.val().trim();

    if (answer.length === 0) {
      input.val('');
    } else {
      const isCorrect = answer === this.answer;
      const data = {answer, isCorrect, isWrong: !isCorrect};
      target.trigger($.Event('problem_answered', data));
      Template.instance().lastAnswer.set(data);
      if (isCorrect) { input.val(''); }
    }

    input.focus();
    return false;
  }
});
