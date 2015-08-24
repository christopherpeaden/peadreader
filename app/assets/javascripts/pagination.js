$(document).ready(function() {
  $("#items").on("click", ".pagination a", function() {
    $(".pagination.top").html("Loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
})
