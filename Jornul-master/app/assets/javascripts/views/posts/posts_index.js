Journal.Views.PostsIndex = Backbone.View.extend({

  template: JST['posts/index'],

  events: {
    "click .delete": "deletePost"
  },

  render: function () {
    var content = this.template({posts: this.collection});
    this.$el.html(content);
    return this;
  },

  deletePost: function (event) {
    var $target = $(event.target);
    var id = $target.data('id');
    var model = this.collection.get(id);
    model.destroy();
  },

  initialize: function (options) {
    this.listenTo(this.collection,
      'remove add reset change:title sync', this.render)
  }

});
