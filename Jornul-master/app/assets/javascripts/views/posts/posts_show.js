Journal.Views.PostsShow = Backbone.View.extend({

  template: JST['posts/show'],

  events: {
    "dblclick h2": "showForm",
    "dblclick p": "showForm",
  },

  render: function () {
    var content = this.template({post: this.model});
    this.$el.html(content);
    return this;
  },

  showForm: function (event) {
    Backbone.history.navigate("posts/"+this.model.id + "/edit", {trigger: true});
  },

  initialize: function (options) {
    this.listenTo(this.model, 'sync', this.render)
  }

});
