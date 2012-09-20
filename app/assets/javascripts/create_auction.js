jQuery(function(){
  $('#new_auction_params').bind("ajax:error", function(event,xhr){
    var errors = $.parseJSON(xhr.responseText).errors
    var errors_element = $("#auction_params_errors")

    errors_element.html("<h4 class='alert-heading'>Please review and correct the following errors:</h4>")
    errors_element.append("<ul>")
    $(errors).each(function(){
      errors_element.append($("<li>" + this + "</li>"))
    });
    errors_element.append("</ul>")
    errors_element.show()
  });

  $('#new_auction_params').bind("ajax:success", function(event,xhr){
    window.location = xhr.auction_path
  })

  $("#auction_params_end_date").datetimepicker({
    dateFormat: 'yy/mm/dd',
    timeFormat: 'hh:mm:ss'
  })
})