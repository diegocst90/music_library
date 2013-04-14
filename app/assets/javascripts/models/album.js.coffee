class DemoBackbone.Models.Album extends Backbone.Model

  urlRoot: ->
    if @isNew()
        "/api/artists"
    else
        "/api/artists/" + @get('artist_id') + "/albums"

  getSongs: (opts)-> 
    songCollection = new DemoBackbone.Collections.Songs({}, {album_id: @get('id'), artist_id: @get('artist_id')})
    songCollection.fetch(opts)
