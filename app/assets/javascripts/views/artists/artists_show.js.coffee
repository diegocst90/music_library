class DemoBackbone.Views.ArtistsShow extends Backbone.View

  template: JST['artists/show']

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    @model.getAlbums(
        success: (albums) =>
            $(@el).html(@template(artist: @model, albums: albums))
    )
    this