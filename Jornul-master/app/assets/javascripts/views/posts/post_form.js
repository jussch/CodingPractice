Journal.Views.PostsForm = Backbone.View.extend({

  template: JST['posts/form'],

  events: {
    "submit .post-form": "updatePost"
  },

  render: function () {
    var content = this.template({post: this.model});
    this.$el.html(content);
    return this;
  },

  updatePost: function (event) {
    event.preventDefault();

    var $target = $(event.target)
    var attributes = $target.serializeJSON();

    this.model.save(attributes.post, {
      success: function () {
        this.collection.add(this.model, {merge: true});
        Backbone.history.navigate("posts/"+this.model.id, {trigger: true});
      }.bind(this),
      error: function (modul, resp) {
        this.model.validationError = resp.responseJSON.errors;
        this.render();
      }.bind(this)
    });
  },

  initialize: function (options) {
    this.listenTo(this.model, 'sync', this.render);
  }

  });
