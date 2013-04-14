class DemoBackbone.Views.AlbumsShow extends Backbone.View

  template: JST['albums/show']

  initialize: (options) ->
    @model.on('reset', @render, this)
    @artist_id = options.artist_id || 0

  render: ->
    @model.getSongs(
        success: (songs) =>
            $(@el).html(@template(album: @model, songs: songs, artist_id: @artist_id))
    )
    this