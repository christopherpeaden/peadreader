$(function() {
  $("div.container").on("click", ".pagination a", function() {
    $.get(this.href, null, null, "script")
    return false;
  });
});
