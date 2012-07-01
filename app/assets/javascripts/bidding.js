jQuery(function(){
  $('#buy_it_now').bind("ajax:error", function(event,xhr){
    var errors = $.parseJSON(xhr.responseText).errors
    var errors_element = $("#buy_it_now_errors")

    errors_element.html("<h4 class='alert-heading'>Please review and correct the following errors:</h4>")
    errors_element.append("<ul>")
    $(errors).each(function(){
      errors_element.append($("<li>" + this + "</li>"))
    });
    errors_element.append("</ul>")
    errors_element.show()
  });

  $('#buy_it_now').bind("ajax:success", function(event,xhr){
    window.location = xhr.auction_path
  })
})
