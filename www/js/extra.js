//$(document).on("keydown", "input", function(e) {
  //console.log('you did a keydown!');
  //alert("keyup!" + e.keyCode);
//});
//$(document).on("keydown", "input", function(e) {
  //$(e.target).removeClass("empty");
//});
//function newKeyUpDown(originalFunction, eventType) {
    //return function() {
        //if ("ontouchstart" in document.documentElement) { // if it's a touch device, or test here specifically for android chrome
            //var $element = $(this), $input = null;
            //if (/input/i.test($element.prop('tagName')))
                //$input = $element;
            //else if ($('input', $element).size() > 0)
                //$input = $($('input', $element).get(0));

            //if ($input) {
                //var currentVal = $input.val(), checkInterval = null;
                //$input.focus(function(e) {
                    //clearInterval(checkInterval);
                    //checkInterval = setInterval(function() {
                        //if ($input.val() != currentVal) {
                            //var event = jQuery.Event(eventType);
                            //currentVal = $input.val();
                            //event.which = event.keyCode = (currentVal && currentVal.length > 0) ? currentVal.charCodeAt(currentVal.length - 1) : '';
                            //$input.trigger(event);
                        //}
                    //}, 30);
                //});
                //$input.blur(function() {
                    //clearInterval(checkInterval);
                //});
            //}
        //}
        //return originalFunction.apply(this, arguments);
    //};
//}
//$.fn.keyup = newKeyUpDown($.fn.keyup, 'keyup');
//$.fn.keydown = newKeyUpDown($.fn.keydown, 'keydown');
