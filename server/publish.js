Meteor.publish('userData', function() {
  if (this.userId) {
    return Meteor.users.find({ _id: this.userId }, { fields: {
      'services.google.given_name': 1,
      'services.google.email': 1
    }
  }
    );
  } else {
    this.ready();
  }
});
