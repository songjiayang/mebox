window.Views ||= {}

class Views.BaseView
  el: 'body'
  ui: {}

  constructor: ->
    @$el = $(@el)
    @refreshUI()

  refreshUI: ->
    @$ui = {}
    for k, v of @ui
      @$ui[k] = @$el.find(v)

  render: ->
  cleanup: ->

class Views.ApplicationView
  render: ->
  cleanup: ->
