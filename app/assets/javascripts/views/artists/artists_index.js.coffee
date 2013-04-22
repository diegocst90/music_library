class DemoBackbone.Views.ArtistsIndex extends Backbone.View

  template: JST['artists/index']

  events:
    "click a.new_artist": "newArtist"

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendArtist, this)
    this

  appendArtist: (artist) ->
    view = new DemoBackbone.Views.ArtistItem(model: artist)
    @$('#list_artists').append(view.render().el)

  newArtist: ->
    Backbone.history.navigate("artists/new", {trigger: true})