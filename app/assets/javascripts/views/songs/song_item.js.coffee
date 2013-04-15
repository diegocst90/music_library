class DemoBackbone.Views.SongItem extends Backbone.View

  template: JST['songs/song_item']

  events:
    "click a": "selectSong"

  initialize: (options)->
    @artist_id = options.artist_id || 0
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(song: @model))
    this

  selectSong: ->
    Backbone.history.navigate("artists/" + @artist_id.toString() + "/albums/" + @model.get("album_id") + "/songs/" + @model.get("id"), {trigger: true})