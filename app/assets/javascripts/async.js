$(function() {
  $("#refresh-btn").click(function() {
  $.ajax({
    type: "GET",
    contentType: "application/json; charset=utf-8",
    url: "/refresh",
    dataType: "json",
    success: function(result) {
      for(var x = 0; x < result.length; x++) 
        document.createTextNode(result[x]["title"]);
      };
    },
    error: function() {
      alert("Oops!");
    }
  });
  })
});
