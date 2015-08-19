$(document).ready(function() {
  $("#feed_items").on("click", ".pagination a", function() {
    $(".pagination").html("Loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
})
