$(document).ready(function () {
  $('#sidebar li ul').hide();

  $('#sidebar li .caret').click(function(e) {
    $('ul', this).slideToggle(300);
    e.stopPropagation();
  })

  $('#sidebar').click(function() {
    if ($('#sidebar li ul').is(':visible')) {
      $('#sidebar li ul').slideUp();
    }
  });
});
