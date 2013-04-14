class DemoBackbone.Collections.Albums extends Backbone.Collection
  
  url: '/api/artists/'
  model: DemoBackbone.Models.Album
  
  initialize: (models, options) ->
    artist_id = options.artist_id || 0
    @setURLByArtist(artist_id) if (artist_id)


  setURLByArtist: (artist_id) ->
    @url += artist_id.toString() + '/albums'