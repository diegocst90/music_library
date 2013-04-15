class DemoBackbone.Routers.Albums extends Backbone.Router
  routes:
    'artists/:artist_id/albums/:id': 'show'

  initialize: ->
    

  show: (artist_id, id) ->
    album = new DemoBackbone.Models.Album({id: id, artist_id: artist_id})
    album.fetch
        success: ->
            view = new DemoBackbone.Views.AlbumsShow(model: album)
            $('#content_artists').html(view.render().el)