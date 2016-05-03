$(function() {
  $("div.container").on("click", ".pagination a", function() {
    $.get(this.href, null, null, "script")
    $(window).scrollTop(0);
    return false;
  });
});
