
var theme = "default";

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
		var old_id = $("#nav a.active").attr("id");
		var new_id = $(this).attr("id");
		$("#nav a.active").removeClass("active");
		$(this).addClass("active");
		// choose image based on current theme
		var fname = "plots/" + theme + "/" + new_id + ".png";
		var img = $("#" + new_id + "_item img");
		img.attr("src", fname);
		if (old_id != new_id) {
		    // animate change of page
		    $("#" + old_id + "_item").slideUp();
		    $("#" + new_id + "_item").slideDown();
		}
		// do not show theme controls on intro page
		if (new_id == "intro") {
		    $("#themer").slideUp();
		} else {
		    $("#themer").slideDown();
		}
	    });

	$("#themer a").click(function(e) {
		e.preventDefault();
		theme = $(this).attr("id").substring(6);
		$("#themer .active_theme").removeClass("active_theme");
		$(this).addClass("active_theme");
		$("#nav a.active").click();
	    });

	$("#themer #theme_default").click();
});