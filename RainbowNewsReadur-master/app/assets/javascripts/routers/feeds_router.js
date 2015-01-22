NewsReader.Routers.Feeds = Backbone.Router.extend({

  initialize: function(options) {
    this.$rootEl = $(options.rootEl);
    this.collection = options.collection
  },

  routes:  {
    "" : "index",
    "feeds": "index",
    "feeds/new" : "newFeed",
    "feeds/:id" : "feedShow"
  },

  index: function() {
    var view = new NewsReader.Views.FeedsIndex({collection: this.collection});
    this.swap(view);
  },

  newFeed: function () {
    var view = new NewsReader.Views.FeedsForm({collection: this.collection});
    this.swap(view);
  },

  feedShow: function(id) {
    var model = this.collection.getOrFetch(id);
    var view = new NewsReader.Views.FeedsShow({model: model});
    this.swap(view);
  },

  swap: function(newView) {
    if (this.currentView && this.currentView.leave) {
      this.currentView.leave();
    }
    this.currentView = newView;
    this.$rootEl.html(this.currentView.render().$el);
  }

});
