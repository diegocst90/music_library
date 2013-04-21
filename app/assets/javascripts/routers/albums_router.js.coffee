class DemoBackbone.Routers.Albums extends Backbone.Router
  routes:
    'artists/:artist_id/albums/:id': 'show'

  initialize: ->
    @collection = null

  updateCollection: (new_collection) ->
    @collection = new_collection

  show: (artist_id, id) ->
    album = @collection?.get(id)
    if album
        window.DemoBackbone.Routers.songs_router.updateCollection(null)
        @renderAlbum(album)
    else
        album = new DemoBackbone.Models.Album({id: id, artist_id: artist_id})
        album.fetch
            data:
                songs: true
            success: =>
                collection_songs = new DemoBackbone.Collections.Songs(album.get("songs"), {artist_id: artist_id, album_id: album.get("id")})
                window.DemoBackbone.Routers.songs_router.updateCollection(collection_songs)
                @renderAlbum(album)

  renderAlbum: (album) ->
    view = new DemoBackbone.Views.AlbumsShow(model: album)
    $('#content_artists').html(view.render().el)