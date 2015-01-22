Pokedex.RootView.prototype.renderPokemonDetail = function (pokemon) {
  var deets = $("<div>").addClass("detail");
  var image = $("<img>").attr("src", pokemon.attributes.image_url);
  deets.append(image);

  for (var attribute in pokemon.attributes) {
    if (attribute === "image_url") {continue;}
    var $li = $("<li>").append(attribute)
    if (attribute === "moves") {
      var $moveUl = $("<ul class='moves'>");
      for (var move in pokemon.attributes[attribute]) {
        var $moveLi = $("<li>")
        $moveLi.append(_.escape(pokemon.attributes[attribute][move]))
        $moveUl.append($moveLi);
      }
      $li.append($moveUl)
    } else {
      $li.append(": "+_.escape(pokemon.attributes[attribute]))
    }
    deets.append($li)
  }

  var $toys = $("<ul>")
  $toys.addClass("toys")

  pokemon.fetch({
    success: function (pokemon) {
      pokemon.toys().each(function (toy) {
        this.addToyToList(toy);
      }.bind(this))
    }.bind(this)
  })
  // for (var i = 0; i < pokemon.toys().length; i++) {
  //   var $toyLi = $("<li>");
  //   $toyLi.append(pokemon.toys().models[i].attributes.name);
  //   $toys.append($toyLi);
  // }
  deets.append($toys);

  this.$pokeDetail.append(deets);
};

Pokedex.RootView.prototype.selectPokemonFromList = function (event) {
  var pokeId = $(event.currentTarget).data("id");
  var pokeman = this.pokes.get(pokeId);
  this.renderPokemonDetail(pokeman);
};
