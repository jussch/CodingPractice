window.NewsReader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    this.feeds = new NewsReader.Collections.Feeds();
    this.feeds.fetch();
    this.router = new NewsReader.Routers.Feeds({collection: this.feeds, rootEl: "div#content"});
    Backbone.history.start();
  }
};

$(document).ready(function(){
  NewsReader.initialize();
});
