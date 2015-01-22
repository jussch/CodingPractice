TrelloClone.Views.BoardsForm = Backbone.CompositeView.extend({

  template: JST['boards/form'],

  initialize: function () {
    this.listenTo(this.model, 'sync', this.render);
  },

  events: {
    'submit form.board-form': 'newBoard'
  },

  render: function () {
    var content = this.template({board: this.model});
    this.$el.html(content);
    return this;
  },

  newBoard: function (event) {
    event.preventDefault();
    var $target = $(event.currentTarget);
    var params = $target.serializeJSON().board;

    this.model.save(params, {
      success: function () {
        this.collection.add(this.model, {merge: true});
        Backbone.history.navigate("boards/"+this.model.id, {trigger: true});
      }.bind(this)
    })
  }

});
