$(document).ready(function() {
  $("#entries").on("click", ".pagination a", function() {
    $(".pagination").html("Loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
})
