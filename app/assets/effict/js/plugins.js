// Avoid `console` errors in browsers that lack a console.
(function() {
    var method;
    var noop = function noop() {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());

// Place any jQuery/helper plugins in here.

// StupidTable: sorteren van tabellen */

(function(f){f.fn.stupidtable=function(l){return this.each(function(){var j=f(this);l=l||{};l=f.extend({},{"int":function(e,b){return parseInt(e,10)-parseInt(b,10)},"float":function(e,b){return parseFloat(e)-parseFloat(b)},string:function(e,b){return e<b?-1:e>b?1:0}},l);j.on("click","th",function(){var e=j.children("tbody").children("tr"),b=f(this),m=0;j.find("th").slice(0,b.index()).each(function(){var b=f(this).attr("colspan")||1;m+=parseInt(b,10)});var p=b.data("sort")||null;if(null!==p){var n=
"asc"===b.data("sort-dir")?"desc":"asc";j.trigger("beforetablesort",{column:m,direction:n});setTimeout(function(){var g=[],c=l[p];e.each(function(b,c){var a=f(c).children().eq(m),d=a.data("sort-value"),a="undefined"!==typeof d?d:a.text();g.push(a)});var h=[],d=g.slice(0),a=g.slice(0).reverse(),k=g.slice(0).sort(c);if((d&&k&&!(d<k||k<d)||a&&k&&!(a<k||k<a))&&null!==b.data("sort-dir")){g.reverse();for(c=g.length-1;0<=c;c--)h.push(c)}else{h=g.slice(0).sort(c);c=[];for(a=d=0;a<g.length;a++){for(d=f.inArray(g[a],
h);-1!=f.inArray(d,c);)d++;c.push(d)}h=c}j.find("th").data("sort-dir",null).removeClass("sorting-desc sorting-asc");b.data("sort-dir",n).addClass("sorting-"+n);c=e.slice(0);for(a=d=0;a<h.length;a++)d=h[a],c[d]=e[a];h=f(c);j.children("tbody").append(h);j.trigger("aftertablesort",{column:m,direction:n})},10)}})})}})(jQuery);