TrelloClone.Views.ListsForm = Backbone.CompositeView.extend({
  template: JST["lists/form"],

  initialize: function (options) {
    this.listenTo(this.model, 'sync', this.render);
    this.board = options.board;
  },

  events: {
    'submit form.list-form': 'newList'
  },

  render: function () {
    var content = this.template({list: this.model})
    this.$el.html(content);
    return this;
  },

  newList: function (event) {
    event.preventDefault();
    var $target = $(event.currentTarget);
    var params = $target.serializeJSON().list;
    params.board_id = this.board.id;

    this.model.save(params, {
      success: function() {
        this.board.lists().add(this.model);
        Backbone.history.navigate("boards/"+this.board.id, {trigger: true})
      }.bind(this)
    });
  }
});
