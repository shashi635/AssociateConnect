PROWEBAPPS = (function() { 
    var actionCounter = 0; 
    var ROTATION_CLASSES = { 
        "0": "none", 
        "90": "right", 
        "-90": "left", 
        "180": "flipped" 
    }; 
     
     
    function monitorOrientationChanges() { 
        var canDetect = "onorientationchange" in window; 
        var orientationTimer = 0;  
         
        $(window).bind(canDetect ? "orientationchange" : "resize", function(evt) { 
            clearTimeout(orientationTimer); 
            orientationTimer = setTimeout(function() { 
                // given we can only really rely on width and height at this stage,  
                // calculate the orientation based on aspect ratio 
                var aspectRatio = 1; 
                if (window.innerHeight !== 0) { 
                    aspectRatio = window.innerWidth / window.innerHeight; 
                } // if 
 
                // determine the orientation based on aspect ratio 
                var orientation = aspectRatio <= 1 ? "portrait" : "landscape"; 
 
                // if the event type is an orientation change event, we can rely on 
                // the orientation angle 
                var rotationText = null; 
                if (evt.type == "orientationchange") { 
                    rotationText = ROTATION_CLASSES[window.orientation.toString()]; 
                } // if 
 
                $(window).trigger("reorient", [orientation, rotationText]); 
            }, 500); 
        });         
    } // monitorOrientationChanges 
     
