/*$(function() {
  $("#refresh-btn").click(function() {
  $.ajax({
    type: "GET",
    contentType: "application/json; charset=utf-8",
    url: "/refresh",
    dataType: "json",
    success: function(result) {
      for(var x = 0; x < result.length; x++) {
        $("#so").html(result[x]["title"]);
      };
      },
    error: function() {
      alert("Oops!");
    }
  });
  })
function GetData() {
}); */

/*
    // 1. Instantiate XHR - Start 
$(function() {


  var btn = document.getElementById("ajax-btn");
  btn.addEventListener("click", function() {
    var xhr; 
    if (window.XMLHttpRequest) 
      xhr = new XMLHttpRequest(); 
    else if (window.ActiveXObject) 
      xhr = new ActiveXObject("Msxml2.XMLHTTP");
    else 
      throw new Error("Ajax is not supported by your browser");

    function sendXhrRequest() {
      xhr.open('GET', 'http://localhost:3000/test_ajax')
      xhr.send(null);
    }
      // 1. Instantiate XHR - End
      
      // 2. Handle Response from Server - Start
  xhr.onreadystatechange = function () {
    if (xhr.readyState < 4)
      btn.innerHTML = "Refreshing...";
    else if (xhr.readyState === 4) {
      if (xhr.status == 200 && xhr.status < 300) {
        btn.innerHTML = "Refresh";
        var response = JSON.parse(xhr.responseText);
        for(var x = 0; x < response.length; x++) {

          var li = document.createElement("li");
          var itemTitle = document.createTextNode(response[x]["title"]);
          var publishedAt = document.createTextNode(response[x]["published"]);

          if(response[x]["image_thumbnail_url"]) {
            var thumbnailUrl = document.createTextNode(response[x]["image_thumbnail_url"]);
            li.appendChild(thumbnailUrl);
          }

          li.appendChild(itemTitle);
          li.appendChild(publishedAt);
          list = document.getElementsByClassName("list-group")[0];
          list.insertBefore(li, list.childNodes[x]);

        }
      }
    }
  }

    // 2. Handle Response from Server - End

    // 3. Specify your action, location and Send to the server - Start   
    setInterval(sendXhrRequest, 4000);
    // 3. Specify your action, location and Send to the server - End
  })
})
*/
