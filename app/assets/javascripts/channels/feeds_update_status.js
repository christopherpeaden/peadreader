(function() {
  App.feedsUpdateStatus = App.cable.subscriptions.create("FeedsUpdateStatusChannel", {
    connected: function() {},
    disconnected: function() {},

    received: function(data) {
      var refreshButton = document.getElementById("refresh-btn");
      var refreshDiv = document.getElementById("refresh"); 

      if (typeof data != "object") {
        if (refreshButton != null) {
          var textData = document.createTextNode(data);
          refreshDiv.replaceChild(textData, refreshButton);
        } else {
          var textData = document.createTextNode(data);
          refreshDiv.replaceChild(textData, refreshDiv.childNodes[1]);

          if (data == "Feeds have been successfully updated.") {refreshDiv.className = "alert alert-success";}
        }
      } else {
        var itemList = document.getElementsByClassName("list-group")[0];
        var items = document.getElementById("items").childNodes[1].childNodes;

        for(var x = 0; x <= items.length; x++) {
          if(items[x].dataset != undefined) {
            var dataPublished = data['item'].match(/2.*C/)[0];

            console.log(x);
            console.log(items[x]);
            if (dataPublished > items[x].dataset.published) {
              //$('#items .list-group').prepend(data['item']); 
              $(data["item"]).insertBefore(items[x]);
              $("").insertBefore(items[x]);
              break;
            }
	  }
	}
      }
    },


    update: function() {
      return this.perform('update');
    }
  });

  $(document).on("click", "#refresh-btn", function(event) {
    App.feedsUpdateStatus.update();
    return event.preventDefault();
  })
  
}).call(this);
