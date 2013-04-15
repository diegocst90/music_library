class DemoBackbone.Views.ArtistsIndex extends Backbone.View

  template: JST['artists/index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendArtist, this)
    this

  appendArtist: (artist) ->
    view = new DemoBackbone.Views.ArtistItem(model: artist)
    @$('#list_artists').append(view.render().el)