class DemoBackbone.Views.ArtistsIndex extends Backbone.View

  template: JST['artists/index']

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template(artists: @collection))
    this