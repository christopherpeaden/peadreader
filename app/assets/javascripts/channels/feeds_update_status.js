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

          if(data == "Feeds have been successfully updated.") {refreshDiv.className = "alert alert-success"};
          if(data.slice(0, 5) == "There") {refreshDiv.className = "alert alert-danger"};
        }

      } else {
        var items = document.getElementById("items").children[0];
        
        if(items.children.length < 1) {
            var parser = new DOMParser();
            var doc = parser.parseFromString(data["item"], "text/html");
            items.appendChild(doc.firstChild);
        } else {
          var positionFound = false;

          for(var x = 0; x < items.children.length; x++) {
              var dataPublished = data['item'].match(/2.*C/)[0];

              if (items.children[x].children[1]) {
                  if (dataPublished > items.children[x].children[1].children[0].dataset.published) {
                      var parser = new DOMParser();
                      var doc = parser.parseFromString(data["item"], "text/html");
                      items.insertBefore(doc.firstChild, items.children[x]);
                      positionFound = true;
                      break;
                  }
              } else if(items.children[x]) {
                  if (dataPublished > items.children[x].dataset.published) {
                      var parser = new DOMParser();
                      var doc = parser.parseFromString(data["item"], "text/html");
                      items.insertBefore(doc.firstChild, items.children[x]);
                      positionFound = true;
                      break; 
                  }
              }
          }
          if (positionFound == false) {
              var parser = new DOMParser();
              var doc = parser.parseFromString(data["item"], "text/html");
              items.appendChild(doc.firstChild);
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
