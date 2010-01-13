
/* Copyright (C) 2010 Felix Andrews <felix@nfrac.org> */

var theme = "default";
var imageSrcBase = "";
var currentAnchor = "INIT";
var currentItem = "intro";

// repeatedly check the anchor in the URL, to detect back/forward
function checkAnchor() {
    if (currentAnchor != document.location.hash) {  
        currentAnchor = document.location.hash;
	var newItem;
        if ((!currentAnchor) || (currentAnchor == "#")) {
	    newItem = "intro";
	} else {
            var splits = currentAnchor.substring(1).split('&theme=');
            newItem = splits[0];
	    theme = (splits.length > 1) ? splits[1] : "default";
        }
	loadItem(newItem);
    }
}  

function setAnchor(newItem) {
    var a;
    if (newItem == "intro") {
	a = "#";
    } else {
	if (theme == "default") {
	    a = "#" + newItem;
	} else {
	    a = "#" + newItem + "&theme=" + theme;
	}
    }
    document.location.hash = a;
}

function loadItem(newItem) {
    // set menu item to 'active'
    $("#nav a.active").removeClass("active");
    var navEl = $("#nav " + jq("nav_" + newItem));
    navEl.addClass("active");
    if (newItem != "intro") {
	// expand the corresponding nav group
	navEl.parent().parent().parent().slideDown();
	// choose image based on current theme
	//imageSrcBase = "";
	var fname = imageSrcBase + "plots/" + theme + "/" + newItem + ".png";
	$(jq(newItem) + " img").attr("src", fname);
    }
    // animate change of page
    if (currentItem != newItem) {
	$(jq(currentItem)).slideUp();
	currentItem = newItem;
    }
    $(jq(newItem)).slideDown();
    // do not show theme controls on intro page
    if (newItem == "intro") {
	$("#themer").slideUp();
    } else {
	$("#themer").slideDown();
	$("#themer .active_theme").removeClass("active_theme");
	$("#themer #theme_" + theme).addClass("active_theme");
    }
}

/* constructs an id selector, escaping '.' and ':' (jquery.com) */
function jq(myid) { 
    return '#' + myid.replace(/(:|\.)/g,'\\$1');
}

jQuery(function(){
	$(".groupname").hide();
	$(".item").hide();
	//$("#intro").show();

	/*$("#nav").accordion({ header: "li.group" });*/
	$("#nav li.group a").click(function() {
		$(this).parent().next().slideToggle();
		return false;
	    }).parent().next().hide();

	$("#nav a.nav").click(function(e) {
		e.preventDefault();
		var newItem = $(this).attr("id").substring(4);
		// set the URL anchor, will trigger loadItem()
		setAnchor(newItem);
	    });

	$("#themer a").click(function(e) {
		e.preventDefault();
		theme = $(this).attr("id").substring(6);
		// set the URL anchor, will trigger loadItem()
		setAnchor(currentItem);
	    });

	checkAnchor();
	setInterval("checkAnchor()", 300);
});