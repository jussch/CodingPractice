Journal.Routers.Posts = Backbone.Router.extend({
  routes: {
    "": "index",
    "posts": "index",
    "posts/new": "new",
    "posts/:id": "show",
    "posts/:id/edit": "edit"
  },
  initialize: function (options) {
    this.$sidebar = $(options.divSidebar);
    this.$content = $(options.divContent);
    this.collection = options.collection;
    this.index();
  },

  index: function () {
    var index = new Journal.Views.PostsIndex({ collection: this.collection});
    this.$sidebar.html(index.render().$el);
  },

  show: function (id) {
    var post = this.collection.getOrFetch(id);
    var show = new Journal.Views.PostsShow({ model: post});
    show.render();
    this.$content.html(show.$el);
  },

  edit: function (id) {
    var post = this.collection.getOrFetch(id);
    var form = new Journal.Views.PostsForm({ model: post, collection: this.collection});
    form.render();
    this.$content.html(form.$el);
  },

  new: function () {
    var post = new Journal.Models.Post();
    var form = new Journal.Views.PostsForm({model: post, collection: this.collection});
    form.render();
    this.$content.html(form.$el);
  }
});
