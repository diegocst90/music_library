class DemoBackbone.Routers.Songs extends Backbone.Router
  routes:
    'artists/:artist_id/albums/:album_id/songs/:id': 'show'

  initialize: ->
    @collection = null

  updateCollection: (new_collection) ->
    @collection = new_collection

  show: (artist_id, album_id, id) ->
    song = @collection?.get(id)
    if song
        @renderSong(song, artist_id)
    else
        song = new DemoBackbone.Models.Song({id: id, artist_id: artist_id, album_id: album_id})
        song.fetch
            success: =>
                @renderSong(song, artist_id)

  renderSong: (song, artist_id) ->
    view = new DemoBackbone.Views.SongsShow(model: song, artist_id: artist_id)
    $('#content_artists').html(view.render().el)