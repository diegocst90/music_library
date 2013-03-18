class DemoBackbone.Models.Artist extends Backbone.Model

  getAlbums: (opts)-> 
    albumCollection = new DemoBackbone.Collections.Albums({}, {artist_id: @get('id')})
    albumCollection.fetch(opts)
