class DemoBackbone.Views.ArtistsNew extends Backbone.View

  template: JST['artists/new']
  newArtistForm: null

  events:
    "click a.back_link" : "backArtists"
    "submit form#form_new_artist" : "saveArtist"
    "click button.clear_form" : "clearNewArtistForm"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(artist: @model))
    @newArtistForm = @$("form#form_new_artist")[0]
    $(@newArtistForm).validationEngine()
    this

  saveArtist: ->
    alert("aah")

  clearNewArtistForm: ->
    @newArtistForm.reset()

  backArtists: ->
    Backbone.history.navigate("", {trigger: true})