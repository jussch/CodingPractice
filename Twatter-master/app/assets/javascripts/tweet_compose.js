$.TweetCompose = function (el){
  this.$el = $(el);
  this.$inputs = this.$el.children(":input").add(this.$el.children('label').children(':input'));
  this.$contentText = this.$el.children("label").children('textarea');

  this.$contentText.on("keyup", this.inputBox.bind(this))

  this.$el.children("input").on("click", this.submit.bind(this))

};

$.TweetCompose.prototype.submit = function (event){
  event.preventDefault();

  this.$inputs.prop("disabled", true);


  var content = this.$contentText.val();
  var mention = this.$el.children('label select').val();

  $.ajax({
    url: "/tweets/",
    type: "POST",
    data: {tweet: {content: content, mentioned_user_ids: mention}},
    dataType: "json",
    success: this.handleSuccess.bind(this)
  })

}

$.TweetCompose.prototype.clearInput = function (){
  this.$inputs.empty();
}

$.TweetCompose.prototype.handleSuccess = function (infor){
  console.log(infor)
  $('.twitter-feed').append('<li>'+infor.content)

  this.clearInput();
  this.$inputs.prop("disabled", false);
}


$.TweetCompose.prototype.inputBox = function (event) {
  this.$el.children('.chars-left').empty();
  this.$el.children('.chars-left').append(140 - this.$contentText.val().length)
};

$.fn.tweetCompose = function (options) {
  return this.each(function () {
    new $.TweetCompose(this, options);
  });
};

$(function () {
  $(".tweet-compose").tweetCompose();
});
