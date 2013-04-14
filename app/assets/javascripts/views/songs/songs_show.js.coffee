class DemoBackbone.Views.SongsShow extends Backbone.View

  template: JST['songs/show']

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(song: @model))
    this