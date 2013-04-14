class DemoBackbone.Collections.Songs extends Backbone.Collection

  url: '/api/artists/'
  model: DemoBackbone.Models.Song

  initialize: (models, options) ->
    artist_id = options.artist_id || 0
    album_id = options.album_id || 0
    @setURLByAlbum(artist_id, album_id) if (artist_id and album_id)


  setURLByAlbum: (artist_id, album_id) ->
    @url += artist_id.toString() + '/albums/' + album_id.toString() + "/songs"
