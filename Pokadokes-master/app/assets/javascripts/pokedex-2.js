Pokedex.RootView.prototype.addToyToList = function (toy) {
  var $peekingmon = $("<li>");
  $peekingmon.append(toy.attributes.name + " " + toy.attributes.happiness + " " + toy.attributes.price);
  $("ul.toys").append($peekingmon);
  $peekingmon.data("id",toy.id);
  $peekingmon.data("pokemon-id",toy.attributes.pokemon_id);
  $peekingmon.on("click", this.selectToyFromList.bind(this));
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) {
  var $justinIsARealBoy = $("<div>");
  $justinIsARealBoy.addClass("detail");
  var $dickImage = $("<img>");
  $dickImage.attr("src", toy.attributes.image_url);

  $justinIsARealBoy.append($dickImage);
  this.$toyDetail.append($justinIsARealBoy);
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var pokeIt = $(event.currentTarget).data("id");
  var slapIt = $(event.currentTarget).data("pokemon-id");
  var pokingIt = new Pokedex.Models.Pokemon({id: slapIt})
  pokingIt.fetch({
    success: function (toyPpoking) {
      toyPpoking.toys().each(function (model) {
        if (model.id === pokeIt) {
          this.renderToyDetail(model);
        }
      }.bind(this));
    }.bind(this)
  });
};
