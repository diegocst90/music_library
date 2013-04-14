class DemoBackbone.Models.Song extends Backbone.Model

  urlRoot: ->
    if @isNew()
        "/api/artists"
    else
        "/api/artists/" + @get('artist_id') + "/albums/" + @get('album_id') + "/songs"