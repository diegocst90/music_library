class DemoBackbone.Views.AlbumItem extends Backbone.View

  template: JST['albums/album_item']

  events:
    "click a": "selectAlbum"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(album: @model))
    this

  selectAlbum: ->
    Backbone.history.navigate("artists/" + @model.get("artist_id") + "/albums/" + @model.get("id"), {trigger: true})