class DemoBackbone.Views.SongsShow extends Backbone.View

  template: JST['songs/show']

  events:
    "click a.back_link": "backAlbum"

  initialize: (options) ->
    @artist_id = options.artist_id || 0
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(song: @model))
    this

  backAlbum: ->
    Backbone.history.navigate("artists/" + @artist_id.toString() + "/albums/" + @model.get("album_id"), {trigger: true})