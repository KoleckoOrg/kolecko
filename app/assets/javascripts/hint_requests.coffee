# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  # Load hint ratings from database
  $.ajax '/napoveda',
    dataType: 'json'
    success: (result) ->
      for hint in result.hints
        form = $(".star-rating-form[data-hint=#{hint.id}]")
        $('input.rating', form).val(hint.rating).change()

  # Highlight stars on mouse over
  $(document).on 'mouseenter', '.star:not(.frozen)', ->
    $(this).prevAll().addBack().find('i').removeClass('far')
    $(this).prevAll().addBack().find('i').addClass('fas')
    $(this).nextAll().find('i').removeClass('fas')
    $(this).nextAll().find('i').addClass('far')

  # Un-highlight stars on mouse out
  $(document).on 'mouseleave', '.star:not(.frozen)', ->
    $(this).prevAll().addBack().find('i').removeClass('fas')
    $(this).prevAll().addBack().find('i').addClass('far')
    $(this).nextAll().find('i').removeClass('far')
    $(this).nextAll().find('i').addClass('fas')

  # Function to reset stars to original state according to form hidden field
  resetStars = (element) ->
    $('.star', element).each (index) ->
      form = $(this).closest('.star-rating-form')
      rating = $('input[name="hint[rating]"]', form).val()
      if $(this).data('rating') <= rating
        $('i', this).removeClass('far')
        $('i', this).addClass('fas')
      else
        $('i', this).removeClass('fas')
        $('i', this).addClass('far')

  # Show current rating when mouse leaves the widget
  $(document).on 'mouseleave', '.star-rating:not(.frozen)', ->
    resetStars(this)

  # Show current rating when hidden field updated
  $(document).on 'change', '.rating', ->
    resetStars($(this).closest('.star-rating-form'))

  # Update hint rating when a star is clicked
  $(document).on 'click', '.star:not(.frozen)', ->
    form = $(this).closest('form')
    $('.rating', form).val($(this).data('rating'))
