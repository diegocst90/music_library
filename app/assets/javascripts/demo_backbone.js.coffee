window.DemoBackbone =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new DemoBackbone.Routers.Artists()
    Backbone.history.start()

$(document).ready ->
  DemoBackbone.initialize()
