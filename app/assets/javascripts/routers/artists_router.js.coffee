class DemoBackbone.Routers.Artists extends Backbone.Router
  routes:
    '': 'index'
    'artists/:id': 'show'

  initialize: ->

  updateCollection: (new_collection) ->
    @collection = new_collection

  index: ->
    @collection = new DemoBackbone.Collections.Artists()
    @collection.fetch()
    view = new DemoBackbone.Views.ArtistsIndex(collection: @collection)
    $('#content_artists').html(view.render().el)

  show: (id) ->
    if @collection
        artist = @collection.get(id)
        window.DemoBackbone.Routers.albums_router.updateCollection(null)
        @renderArtist(artist)
    else
        artist = new DemoBackbone.Models.Artist({id: id})
        artist.fetch
            data:
                albums: true
            success: =>
                collection_albums = new DemoBackbone.Collections.Albums(artist.get("albums"), {artist_id: artist.get("id")})
                window.DemoBackbone.Routers.albums_router.updateCollection(collection_albums)
                @renderArtist(artist)

  renderArtist: (artist) ->
    view = new DemoBackbone.Views.ArtistsShow(model: artist)
    $('#content_artists').html(view.render().el)