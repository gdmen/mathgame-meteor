/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Problems = new Mongo.Collection(
  'mathgame_models_problems', {
  transform(doc) {
    check(doc._id, String);
    const expr = doc._id;
    const questionObject = math.parse(expr);
    const answerObject = math.eval(expr);
    return _.extend(doc, {
      question: ((() => questionObject
        .toString()
        .replace(/\*/g, '\u00D7')
        .replace(/\//g, '\u00F7')))(),
      questionLatex: ((() => questionObject
        .toTex()
        .replace(/\\cdot/g, '\\times')
        .replace(/\\frac{([^}]*)}{([^}])*}/g, '$1\\div$2')))(),
      answer: answerObject.toFraction(),
      answerLatex: answerObject.toLatex()
    });
  }
}
);

const getRandomValue = function(range) {
  check(range, [Match.Integer]);
  check(range.length, 2);
  check(range[0] <= range[1], true);
  return _.random(range[0], range[1]);
};

const problemTypeMap = {

  ADDITION(config) {
    return `${getRandomValue(config.x)} + ${getRandomValue(config.y)}`;
  },

  SUBTRACTION(config) {
    const y = getRandomValue(config.y);
    return `${y + getRandomValue(config.z)} - ${y}`;
  },

  MULTIPLICATION(config) {
    return `${getRandomValue(config.x)} * ${getRandomValue(config.y)}`;
  },

  DIVISION(config) {
    const y = getRandomValue(config.y);
    return `${y * getRandomValue(config.z)} / ${y}`;
  }
};

Problems.attachSchema(new SimpleSchema({
  type: {
    type: String,
    label: 'type',
    allowedValues: _.keys(problemTypeMap)
  }
}));

if (Meteor.isServer) {
  Problems.allow({insert() { return true; }});
  Meteor.publish('mathgame_models_problems.all', () => Problems.find({}));
}
if (Meteor.isClient) {
  Meteor.subscribe('mathgame_models_problems.all');
}

this.problem = {

  _c: Problems,

  get(_id) {
    check(_id, String);
    return Problems.findOne({_id});
  },

  getRandom(problemType, config) {
    check(problemType, Match.Where(k => problemTypeMap[k] != null));
    const _id = problemTypeMap[problemType](config);
    if (!this.get(_id)) {
      Problems.insert({_id, type: problemType});
    }
    return this.get(_id);
  }
};

for (let problemType of Array.from(_.keys(problemTypeMap))) {
  this[problemType] = problemType;
}

