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
        $('#items').prepend(data['item']); 
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
