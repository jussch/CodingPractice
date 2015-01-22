NewsReader.Views.FeedsShow = Backbone.View.extend({

  initialize: function () {
    this.listenTo(this.model, "sync", this.render);
  },

  template: JST['feeds/show'],

  events: {
    "click .refresh": "refreshEntries"
  },

  render: function () {
    var content = this.template({feed: this.model});
    this.$el.html(content);
    return this;
  },

  refreshEntries: function () {
    this.model.fetch();
  }

})
