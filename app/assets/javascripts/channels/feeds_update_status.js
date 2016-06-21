(function() {
  App.feedsUpdateStatus = App.cable.subscriptions.create("FeedsUpdateStatusChannel", {
    connected: function() {},
    disconnected: function() {},


    received: function(data) {
      refreshButton = document.getElementById("refresh-btn");
      refreshDiv = document.getElementById("refresh"); 

      if (typeof data != "object") {
        if (refreshButton != null) {
          textData = document.createTextNode(data);
          refreshDiv.replaceChild(textData, refreshButton);
        } else {
          textData = document.createTextNode(data);
          refreshDiv.replaceChild(textData, refreshDiv.childNodes[1]);
          if (data == "Feeds have been successfully updated.") {
            refreshDiv.className = "alert alert-success";
          }
        }
      } else {
        //$('#items').prepend(data['item']); 
        var itemDiv = document.getElementById("items");
        var items = itemDiv.childNodes;
        console.log(items);

        $("#hidden-item").prepend(data["item"]);
        var hiddenDiv = document.getElementById("hidden-item");

        for(var x = 0; x < items.length; x++) {
          if (hiddenDiv.childNodes[0].dataset.published < items[x]) {
            itemDiv.insertBefore(data["item"], items.childNodes[x]);
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
