  $(document).ready(function(){
    $(document).ajaxSend(function(event, request, settings) {
       if (window.location.pathname.indexOf("following") < 0){
      $('.product, .flu').remove();
        $('#loading-indicator').show();
      
        console.log(window.location.pathname.indexOf("following") < 0 )
      };
      });

    $(document).ajaxComplete(function(event, request, settings) {
        $('#loading-indicator').hide();
    });
  });