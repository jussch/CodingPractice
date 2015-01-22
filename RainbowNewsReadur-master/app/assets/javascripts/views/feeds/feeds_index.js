NewsReader.Views.FeedsIndex = Backbone.View.extend({

  initialize: function () {
    this.listenTo(this.collection, "sync", this.render);
    this.subViews = [];
  },

  template: JST['feeds/index'],


  render: function () {
    var content = this.template({ feeds: this.collection });
    this.$el.html(content);
    var that = this;
    this.collection.each(function (feed) {
      var view = new NewsReader.Views.FeedsSubview({ model: feed });
      that.$('ul.feeds').append(view.render().$el);
    })
    return this;
  },

  leave: function () {
    this.subViews.forEach(function (subView) {
      subView.leave();
    });
    this.remove();
  }


});
