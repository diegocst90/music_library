class DemoBackbone.Views.AlbumsShow extends Backbone.View

  template: JST['albums/show']

  events:
    "click a.back_link": "backArtist"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(album: @model))
    @model.getSongs(
        success: (songs) =>
            songs.each(@appendSong, this)
    )
    this

  appendSong: (song) ->
    view = new DemoBackbone.Views.SongItem(model: song, artist_id: @model.get("artist_id"))
    @$("#list_songs").append(view.render().el)

  backArtist: ->
    Backbone.history.navigate("artists/" + @model.get("artist_id"), {trigger: true})