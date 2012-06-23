jQuery(function(){
  $('#new_auction_params').bind("ajax:error", function(event,xhr){
    var errors = $.parseJSON(xhr.responseText).errors;

    $("#auction_params_errors").text("")
    $(errors).each(function(){
      $("#auction_params_errors").append($("<p>" + this + "</p>"))
    });
  });

  $('#new_auction_params').bind("ajax:success", function(event,xhr){
    window.location = xhr.auction_path;
  })
})