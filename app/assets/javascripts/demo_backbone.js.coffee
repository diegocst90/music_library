window.DemoBackbone =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new DemoBackbone.Routers.Artists()
    new DemoBackbone.Routers.Albums()
    new DemoBackbone.Routers.Songs()
    Backbone.history.start()

$(document).ready ->
  DemoBackbone.initialize()
