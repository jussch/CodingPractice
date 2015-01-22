TrelloClone.Routers.Root = Backbone.Router.extend({
  initialize: function (options) {
    this.collection = options.collection;
    this.rootEl = options.rootEl;
    this.$rootEl = $(this.rootEl);
    this.rootView = new Backbone.CompositeView();
  },

  routes: {
    "": "boardsIndex",
    "boards/new": "boardsNew",
    "boards/:id": "boardsShow",
    "boards/:boardID/lists/new": "newBoardList"
  },

  swapView: function(newView) {
    if (this.currentView) { this.currentView.remove(); }
    this.currentView = newView;
    this.$rootEl.html(newView.render().$el)
  },

  boardsIndex: function () {
    var view = new TrelloClone.Views.BoardsIndex({collection: this.collection});
    this.swapView(view);
  },

  boardsNew: function () {
    var newModel = new TrelloClone.Models.Board();
    var view = new TrelloClone.Views.BoardsForm({
      collection: this.collection,
      model: newModel
    });
    this.swapView(view);
  },

  boardsShow: function (id) {
    var model = this.collection.getAndFetch(id);
    var view = new TrelloClone.Views.BoardsShow({model: model});
    this.swapView(view);
  },

  newBoardList: function (boardID) {
    var board = this.collection.getAndFetch(boardID);
    var model = new TrelloClone.Models.List();
    var view = new TrelloClone.Views.ListsForm({
      model: model,
      board: board
    });
    this.swapView(view);
  }

});
