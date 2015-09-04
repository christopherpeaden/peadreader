$(document).ready(function () {
  $('#navbar li ul').hide();

  $('#navbar li').hover(
    function() {
      $('ul', this).stop().slideDown(200);
  },
  function () {
    $('ul', this).stop().slideUp(200);
  })
});
