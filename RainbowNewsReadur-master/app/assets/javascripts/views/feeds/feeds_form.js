NewsReader.Views.FeedsForm = Backbone.View.extend({
  initialize: function () {
    this.model = this.model || new NewsReader.Models.Feed();
  },

  template: JST['feeds/form'],

  events: {
    'submit .new-feed': 'newForm'
  },

  render: function () {
    var content = this.template({feed: this.model});
    this.$el.html(content);
    return this;
  },

  newForm: function (event) {
    event.preventDefault();
    var $target = $(event.currentTarget)
    var attributes = $target.serializeJSON();
    this.model.save(attributes.feed, {
      success: function () {
        this.collection.add(this.model, {merge: true});
        Backbone.history.navigate('feeds/'+this.model.id, {trigger: true})
      }.bind(this)
    });
  }
})
