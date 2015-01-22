window.Journal = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    var collection = new Journal.Collections.Posts();
    // collection.fetch({
    //   success: function () {
    //     this.router = new Journal.Routers.Posts({
    //       divSidebar: 'body div.sidebar',
    //       divContent: 'body div.content',
    //       collection: collection
    //     });
    //     Backbone.history.start();
    //   }.bind(this)
    // });

    collection.fetch();
    this.router = new Journal.Routers.Posts({
      divSidebar: 'body div.sidebar',
      divContent: 'body div.content',
      collection: collection
    });
    Backbone.history.start();


  }
};

$(document).ready(function(){
  Journal.initialize();
});
