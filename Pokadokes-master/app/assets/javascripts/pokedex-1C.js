Pokedex.RootView.prototype.createPokemon = function (attrs, callback) {
  var suparman = new Pokedex.Models.Pokemon();
  suparman.save(attrs, {
    success: function (model) {
      this.pokes.add(model);
      this.addPokemonToList(model);
      callback(model);
    }.bind(this)
  });
};

Pokedex.RootView.prototype.submitPokemonForm = function (event) {
  event.preventDefault();
  var pokomono = $(event.currentTarget).serializeJSON();
  this.createPokemon(pokomono, this.renderPokemonDetail.bind(this));
};
