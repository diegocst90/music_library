class DemoBackbone.Routers.Songs extends Backbone.Router
  routes:
    'artists/:artist_id/albums/:album_id/songs/:id': 'show'

  initialize: ->
    

  show: (artist_id, album_id, id) ->
    song = new DemoBackbone.Models.Song({id: id, artist_id: artist_id, album_id: album_id})
    song.fetch
        success: ->
            view = new DemoBackbone.Views.SongsShow(model: song, artist_id: artist_id)
            $('#content_artists').html(view.render().el)