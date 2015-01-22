Journal.Collections.Posts = Backbone.Collection.extend({
  model: Journal.Models.Post,
  url: "/posts",

  getOrFetch: function (id) {
    var that = this;

    var post;
    if (!(post = this.get(id))) {
      post = new Journal.Models.Post({id: id});
      post.fetch({
        success: function () {that.add(post); }
      });
    }

    return post;
  }
})
