window.TrelloClone = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    this.collection = new TrelloClone.Collections.Boards();
    this.collection.fetch();
    this.rootRouter = new TrelloClone.Routers.Root({
      collection: this.collection,
      rootEl: 'div#main'
    });
  }
};

$(document).ready(function() {
  TrelloClone.initialize();
  Backbone.history.start();
})
