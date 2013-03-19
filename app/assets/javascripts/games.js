// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  'user strict';

  $('[data-refresh-strikes=true]')
    .on('mouseenter', 'td', function() {
      $(this).addClass('hover');
    })
    .on('mouseleave', 'td', function() {
      $(this).removeClass('hover');
    })
    .on('click', 'td', function() {
      var $form = $(this).parents('form');
      $form.find('[name="coordinate[x]"]').val($(this).data('x'));
      $form.find('[name="coordinate[y]"]').val($(this).data('y'));
      $.rails.handleRemote($form);
    });
});