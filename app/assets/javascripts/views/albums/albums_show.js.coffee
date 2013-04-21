class DemoBackbone.Views.AlbumsShow extends Backbone.View

  template: JST['albums/show']

  events:
    "click a.back_link": "backArtist"

  initialize: ->
    @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(album: @model))
    if @model.get("songs")
        list_songs = @model.get("songs")
        for song in list_songs
            model_song = new DemoBackbone.Models.Song(song)
            @appendSong(model_song)
    else
        @model.getSongs
            success: (songs) =>
                window.DemoBackbone.Routers.songs_router.updateCollection(songs)
                songs.each(@appendSong, this)
    this

  appendSong: (song) ->
    view = new DemoBackbone.Views.SongItem(model: song, artist_id: @model.get("artist_id"))
    @$("#list_songs").append(view.render().el)

  backArtist: ->
    Backbone.history.navigate("artists/" + @model.get("artist_id"), {trigger: true})