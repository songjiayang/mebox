//= require_tree ./views

MessageBus.start()
MessageBus.callbackInterval = 1000

pageLoad = ->
  className = $('body').attr('data-class-name')
  window.applicationView = try
    eval("new #{className}()")
  catch error
    new Views.ApplicationView()
  window.applicationView.render()

$ ->
  $(document).on 'turbolinks:load', pageLoad
  $(document).on 'turbolinks:before-cache', ->
    window.applicationView.cleanup()
    true
