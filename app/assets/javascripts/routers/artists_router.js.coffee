class DemoBackbone.Routers.Artists extends Backbone.Router
  routes:
    '': 'index'
    'artists/:id': 'show'

  initialize: ->
    @collection = new DemoBackbone.Collections.Artists()
    @collection.fetch()

  index: ->
    view = new DemoBackbone.Views.ArtistsIndex(collection: @collection)
    $('#content_artists').html(view.render().el)

  show: (id) ->
    artist = @collection.get(id)
    view = new DemoBackbone.Views.ArtistsShow(model: artist)
    $('#content_artists').html(view.render().el)