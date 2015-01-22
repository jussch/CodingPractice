NewsReader.Views.FeedsSubview = Backbone.View.extend({

  initialize: function () {
    this.listenTo(this.model, "sync", this.render);
  },

  events: {
    'click .delete-feed': 'deleteFeed'
  },

  template: JST['feeds/subview'],

  tagName: "li",

  render: function () {
    var content = this.template({feed: this.model});
    this.$el.html(content);
    return this;
  },

  deleteFeed: function (event) {
    this.model.destroy({
      success: function () {
        Backbone.history.navigate("feeds", {trigger: true});
      }
    });

  },

  leave: function () {
    this.remove();
  }

})
