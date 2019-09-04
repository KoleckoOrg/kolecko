# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('.show-hint').on 'ajax:success', (event) ->
    [data, status, xhr] = event.detail
    $(this).closest('.hint-target').html(hintText + hintRatingForm);
