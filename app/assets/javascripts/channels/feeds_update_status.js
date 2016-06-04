(function() {
  App.feedsUpdateStatus = App.cable.subscriptions.create("FeedsUpdateStatusChannel", {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      if (typeof data != "object") {
        $('#update-status').html(data);
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
