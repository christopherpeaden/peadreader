$(function() {
  $(".pagination a").on("click", function() {
    $.get(this.href, null, null, "script")
    return false;
  });
});
