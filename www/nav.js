
$(document).ready(function(){
	$(".groupname").hide();
	$(".item").hide();
	$("#intro_item").fadeIn("slow");

	/*$("#nav").accordion({ header: "li.group" });*/
	$("#nav li.group a").click(function() {
		$(this).parent().next().slideToggle();
		return false;
	    }).parent().next().hide();


	$("#nav a.nav").click(function(e) {
		e.preventDefault();
		var old_id = $("a.active").attr("id");
		var new_id = $(this).attr("id");
		$("a.active").removeClass("active");
		$(this).addClass("active");
		$("#" + old_id + "_item").slideUp();
		$("#" + new_id + "_item").slideDown();
	});
});