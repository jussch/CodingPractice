$.FollowToggle = function (el, options) {
  this.$el = $(el);
  this.userId = this.$el.data('user-id') || options.userId;
  this.followState = this.$el.data('initial-followed-state') || options.followState;

  this.render();

  this.$el.on("click", this.handleClick.bind(this))
};

$.FollowToggle.prototype.render = function () {
  this.$el.prop("disabled", false);
  if (this.followState === "followed") {
    this.$el.children('txt').remove();
    this.$el.append('<txt>Unfollow!</txt>');
  } else if (this.followState === "unfollowed") {
    this.$el.children('txt').remove();
    this.$el.append('<txt>Follow!</txt>');
  } else {
    this.$el.prop("disabled", true);
    this.$el.children('txt').remove();
    this.$el.append('<txt>'+this.followState+'</txt>');
  }

};

$.FollowToggle.prototype.handleClick = function (event) {
  event.preventDefault();
  var formData = $(event.currentTarget).serialize();
  var action;
  if (this.followState === "followed") {
    action = "DELETE";
  } else {
    action = "POST";
  }
  $.ajax({
    url: "/users/"+this.userId+"/follow/",
    type: action,
    data: formData,
    dataType: "json",
    success: function () {
      if (this.followState === "unfollowing ") {
        this.followState = "unfollowed";
      } else {
        this.followState = "followed";
      }

      this.render();
    }.bind(this)
  })

  if (this.followState === "followed") {
    this.followState = "unfollowing";
  } else {
    this.followState = "following";
  }

  this.render();

};

$.fn.followToggle = function (options) {
  return this.each(function () {
    new $.FollowToggle(this, options);
  });
};

$(function () {
  $("button.follow-toggle").followToggle();
});
