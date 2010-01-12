
var theme = "default";
var imageSrcBase = "";

$(document).ready(function(){
	$(".groupname").hide();
	$(".item").hide();
	$("#intro_item").fadeIn("slow");

	/* escapes . and : for element id selectors */
	function jq(myid) { 
	    return '#' + myid.replace(/(:|\.)/g,'\\$1');
	}

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
		//imageSrcBase = "";
		var fname = imageSrcBase + "plots/" + theme + "/" + new_id + ".png";
		var img = $(jq(new_id) + "_item img");
		img.attr("src", fname);
		if (old_id != new_id) {
		    // animate change of page
		    $(jq(old_id) + "_item").slideUp();
		    $(jq(new_id) + "_item").slideDown();
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