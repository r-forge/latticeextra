
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
	//if (theme == "default") {
	//    a = "#" + newItem;
	//} else {
	    a = "#" + newItem + "&theme=" + theme;
	//}
    }
    document.location.hash = a;
}

function loadItem(newItem) {
    if (newItem != "intro") {
	var imgEl = $(jq(newItem) + " img");
	// choose image based on current theme
	// uncomment this to use local images:
	//imageSrcBase = "";
	var fname = imageSrcBase + "plots/" + theme + "/" + newItem + ".png";
	if (imgEl.attr("src") != fname) {
	    // add "loading" message first
	    if ($(jq(newItem) + " .loading").length == 0) {
		imgEl.before('<div class="loading">Loading...</div>');
	    }
	    loadEl = $(jq(newItem) + " .loading");
	    loadEl.hide().show("fast");
	    imgEl.fadeTo("fast", 0.5);
	    imgEl.load(function(e) {
		    loadEl.hide("fast");
		    imgEl.fadeTo("fast", 1);
		});
	    imgEl.attr("src", fname);
	}
    }
    // animate change of page
    if (currentItem != newItem) {
	$(jq(currentItem)).slideUp();
	currentItem = newItem;
    }
    $(jq(newItem)).slideDown();
    // set menu item to 'active'
    $("#nav a.active").removeClass("active");
    var navEl = $("#nav " + jq("nav_" + newItem));
    navEl.addClass("active");
    if (newItem != "intro") {
	// expand the corresponding nav group
	openNavGroup(navEl.parents("li.navgroup"));
    }
    // do not show theme controls on intro page
    if (newItem == "intro") {
	$("#themer").fadeOut();
    } else {
	$("#themer").fadeIn();
	$("#themer .active_theme").removeClass("active_theme");
	$("#themer #theme_" + theme).addClass("active_theme");
    }
}

/* constructs an id selector, escaping '.' and ':' (from jquery.com) */
function jq(myid) { 
    return '#' + myid.replace(/(:|\.)/g,'\\$1');
}

function openNavGroup(el) {
    el.siblings("li.navgroup:visible").slideUp();
    el.slideDown();
    el;
}

jQuery(function(){
	$(".groupname").hide();
	$(".item").hide();
	$("#nav li.navgroup").hide();

	/*$("#nav").accordion({ header: "li.group" });*/
	$("#nav li.navhead a").click(function() {
		openNavGroup($(this).parent().next());
		return false;
	    });

	$("#nav li.navgroup a").click(function(e) {
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
		checkAnchor();
		return false;
	    });

	$("a.helplink").click(function(e) {
		e.preventDefault();
		$(this).hide("slow");
		href = $(this).attr("href");
		man = $('<div class="manpage"></div>');
		$(this).after(man);
		man.load(href, function() {
			$(this).find("h2,table:first,div:last").remove();
			$(this).hide().slideDown("slow");
		    });
	    });

	checkAnchor();
	setInterval("checkAnchor()", 300);
});