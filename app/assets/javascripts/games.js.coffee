# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
if $("#timer").length
  value = parseInt $("#timer").html()

  setInterval (->
    $("#timer").html value + " s"
    value += 1
  ), 1000
