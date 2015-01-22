TrelloClone.Views.Card = Backbone.CompositeView.extend({
  template: JST["cards/card"],

  tagName: "li",
  className: "card",

  initialize: function (options) {
    this.listenTo(this.model, 'sync', this.render);
  },

  render: function () {
    var content = this.template({card: this.model})
    this.$el.html(content);
    return this;
  },

  events: {
    'click button.delete-card': 'deleteCard',
    'mouseout': 'hideDelete',
    'mouseover': 'showDelete'
  },

  deleteCard: function (event) {
    var $target = $(event.currentTarget);
    this.model.destroy();
    this.remove();
  },

  showDelete: function (event) {
    this.$('button.delete-card').addClass('revealed')
  },

  hideDelete: function () {
    this.$('button.delete-card').removeClass('revealed')
  }
})
