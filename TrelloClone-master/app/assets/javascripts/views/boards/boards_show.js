TrelloClone.Views.BoardsShow = Backbone.CompositeView.extend({

  template: JST['boards/show'],

  initialize: function () {
    this.listenTo(this.model, 'sync', this.render);
    this.listenTo(this.model.lists(), 'destroy', this.render);
  },

  render: function () {
    var content = this.template({board: this.model});
    this.$el.html(content);

    this.model.lists().each(function (list) {
      var view = new TrelloClone.Views.List({model: list});
      this.addSubview('ul.lists', view)
    }.bind(this))

    return this;
  }

});
