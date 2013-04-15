class DemoBackbone.Views.ArtistsShow extends Backbone.View

  template: JST['artists/show']

  events:
    "click a.back_link": "backArtists"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(artist: @model))
    @model.getAlbums(
        success: (albums) =>
            albums.each(@appendAlbum, this)
    )
    this

  appendAlbum: (album) ->
    view = new DemoBackbone.Views.AlbumItem(model: album)
    @$("#list_albums").append(view.render().el)

  backArtists: ->
    Backbone.history.navigate("", {trigger: true})