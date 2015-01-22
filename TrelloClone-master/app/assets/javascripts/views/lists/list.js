TrelloClone.Views.List = Backbone.CompositeView.extend({
  template: JST["lists/list"],

  tagName: "li",
  className: "list",

  initialize: function (options) {
    this.listenTo(this.model, 'sync', this.render);

  },

  render: function () {
    var content = this.template({list: this.model})
    this.$el.html(content);
    this.model.cards().each(function (card) {
      var view = new TrelloClone.Views.Card({model: card});
      this.addSubview('ul.cards',view);
    }.bind(this))

    this.$('ul.cards').disableSelection();
    this.$('ul.cards').sortable();

    return this;
  },

  events: {
    'click button.delete-list': 'deleteList'
  },

  deleteList: function (event) {
    var $target = $(event.currentTarget);

    this.model.destroy();

    this.remove();
  }
})
