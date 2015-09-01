$(document).ready(function () {
    $('#navbar li ul').hide().removeClass('fallback');
    $('#nav li').hover(
      function() {
        $('ul', this).stop().slideDown(100);
  },
  function () {
    $('ul', this).stop().slideUp(100);
  }
);
