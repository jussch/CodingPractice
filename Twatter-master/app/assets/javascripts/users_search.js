$.UserSearch = function (el) {
  this.$el = $(el);
  this.$input = this.$el.children('input.searcherino');
  this.$results = this.$el.children('ul.users');
  this.$input.on("keyup", this.handleInput.bind(this));
}

$.UserSearch.prototype.handleInput = function(event) {
  var leValue = this.$input.val();

  $.ajax({
    url: "/users/search/",
    type: "GET",
    data: {query: leValue},
    dataType: "json",
    success: function (response) {
      this.renderResults(response);
    }.bind(this)
  });
}


$.UserSearch.prototype.renderResults = function (response){
  this.$results.empty();
  for (var i=0; i< response.length; i++) {
    var user = response[i];

    var $a = $("<a>");
    $a.text(user.username);
    $a.attr("href", "/users/" + user.id)

    var $button = $('<button></button>');
    $button.followToggle({
      userId: user.id,
      followState: user.followed ? "followed" : "unfollowed"
    });

    var $li = $("<li>");
    $li.append($a);
    $li.append($button);

    this.$results.append($li);

  };
}

$.fn.userSearch = function () {
  return this.each(function () {
    new $.UserSearch(this);
  });
};

$(function () {
  $("div.users-search").userSearch();
});
