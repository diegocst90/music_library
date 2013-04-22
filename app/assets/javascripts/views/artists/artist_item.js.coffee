class DemoBackbone.Views.ArtistItem extends Backbone.View

  template: JST['artists/artist_item']

  events:
    "click a.artist": "selectArtist"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(artist: @model))
    this

  selectArtist: ->
    Backbone.history.navigate("artists/" + @model.get("id"), {trigger: true})