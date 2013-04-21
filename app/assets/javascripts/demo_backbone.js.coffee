window.DemoBackbone =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    @Routers.artists_router = new DemoBackbone.Routers.Artists()
    @Routers.albums_router = new DemoBackbone.Routers.Albums()
    @Routers.songs_router = new DemoBackbone.Routers.Songs()
    Backbone.history.start()

$(document).ready ->
  DemoBackbone.initialize()
