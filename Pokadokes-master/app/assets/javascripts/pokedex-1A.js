Pokedex.RootView.prototype.addPokemonToList = function (pokemon) {
  var peeekeemoon = $("<li>");
  peeekeemoon.addClass('poke-list-item');
  peeekeemoon.data('id', pokemon.attributes.id);
  peeekeemoon.append(_.escape(pokemon.attributes.name));
  this.$pokeList.append(peeekeemoon);
};

Pokedex.RootView.prototype.refreshPokemon = function (callback) {
  this.pokes.fetch({
    success: function() {
      this.pokes.forEach(this.addPokemonToList.bind(this));
    }.bind(this)
  });
};
