class DemoBackbone.Models.Artist extends Backbone.Model

  urlRoot: "/api/artists"

  getAlbums: (opts)-> 
    albumCollection = new DemoBackbone.Collections.Albums({}, {artist_id: @get('id')})
    albumCollection.fetch(opts)
