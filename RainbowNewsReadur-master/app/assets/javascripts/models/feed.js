NewsReader.Models.Feed = Backbone.Model.extend({
  urlRoot: "api/feeds/",

  entries: function () {
    if (this._entries) {
      return this._entries;
    }
    this._entries = new NewsReader.Collections.Entries([],{feed: this});
    return this._entries;
  },

  parse: function (response) {
    var latest_entries = response.latest_entries;
    if (latest_entries) {
      this.entries().set(latest_entries, {parse: true});
      delete response.latest_entries;
    }
    return response;
  }
});
