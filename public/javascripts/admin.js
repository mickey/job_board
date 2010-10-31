$(function() {
  $("#accordion tr.title").click(function(){
    $(this).next("tr.form").toggle();
		$(this).next("tr.form").find(".tags_select").multiselect();
  });

	$("form").bind("keypress", function(event){
		if (event.keyCode == 13){
			return false;
		}
	});

	$(".add_tag").keyup(function(event){
	  if(event.keyCode == 13){
			$(this).parent().prev().children(".tags_select").append($("<option></option>").attr("value", $(this).val()).text($(this).val()));
			$(this).val("");
			$(this).parent().prev().children(".tags_select").multiselect('destroy');
			$(this).parent().prev().children(".tags_select").multiselect();
		}
	});

});