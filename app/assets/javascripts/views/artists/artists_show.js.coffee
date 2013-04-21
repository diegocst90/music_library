class DemoBackbone.Views.ArtistsShow extends Backbone.View

  template: JST['artists/show']

  events:
    "click a.back_link": "backArtists"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(artist: @model))
    if @model.get("albums")
        list_albums = @model.get("albums")
        for album in list_albums
            model_album = new DemoBackbone.Models.Album(album)
            @appendAlbum(model_album)
    else
        @model.getAlbums
            success: (albums) =>
                window.DemoBackbone.Routers.albums_router.updateCollection(albums)
                albums.each(@appendAlbum, this)
    this

  appendAlbum: (album) ->
    view = new DemoBackbone.Views.AlbumItem(model: album)
    @$("#list_albums").append(view.render().el)

  backArtists: ->
    Backbone.history.navigate("", {trigger: true})