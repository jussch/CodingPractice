TrelloClone.Collections.Boards = Backbone.Collection.extend({

  model: TrelloClone.Models.Board,

  url: "api/boards",

  getOrFetch: function (id) {
    var board = this.get({id: id})

    if (!board) {
      board = new TrelloClone.Models.Board({id: id});
      board.fetch({
        success: function () {
          this.add(board);
        }.bind(this)
      });
    }

    return board;
  },

  getAndFetch: function (id) {
    var board = this.get({id: id})

    if (!board) {
      board = new TrelloClone.Models.Board({id: id});
      board.fetch({
        success: function () {
          this.add(board);
        }.bind(this)
      });
    } else {
      board.fetch();
    }

    return board;
  }

});
