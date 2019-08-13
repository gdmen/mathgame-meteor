/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Meteor.subscribe('userData');

const currentProblemFlow = new ReactiveVar();

Meteor.startup(() => currentProblemFlow.set(new ProblemFlow({numToSolve: 3})));

Template.body.helpers({

  flow() { return currentProblemFlow.get(); }});

Template.body.events({

  'click a#login-button'(e, t) {
    e.preventDefault();
    Meteor.loginWithGoogle();
  },

  'click a#logout-button'(e, t) {
    e.preventDefault();
    Meteor.logout();
  }
});
