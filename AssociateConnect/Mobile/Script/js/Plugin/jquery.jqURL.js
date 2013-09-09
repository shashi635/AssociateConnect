jQuery.jqURL = {
	url : // returns a string
	function(args) {
		args = 
			jQuery.extend({
				win : window
			},
			args);
		return args.win.location.href;
	},
	
	loc : 
	function(urlstr, args) {
		args = 
			jQuery.extend({
				win : window,
				w : 500,
				h : 500,
				wintype : '_top'
			},
			args);
			
		if (!args.t) {
			args.t = screen.height / 2 - args.h / 2;
		}
		if (!args.l) {
			args.l = screen.width / 2 - args.w / 2;
		}
		if (args['wintype'] == '_top') {
			args.win.location.href = urlstr;
		}
		else {			
			open(
			urlstr,
			args['wintype'],
			'width=' + args.w + ',height=' + args.h + ',top=' + args.t + ',left=' + args.l + ',scrollbars,resizable'
			);
		
		}
		return;
	},
	
	qs :
	function(args) {
		args = jQuery.extend({
			ret : 'string',
			win : window
		},
		args);
		
		if (args['ret'] == 'string') {
			return jQuery.jqURL.url({ win:args.win }).split('?')[1];
			}

		else if (args['ret'] == 'object') {
			
			var qsobj = {};
			var thisqs = jQuery.jqURL.url({ win:args.win }).split('?')[1];
			
			if ( thisqs ) {
				var pairs = thisqs.split('&');
				for ( i=0;i<pairs.length;i++ ) {
					var pair = pairs[i].split('=');
					qsobj[pair[0]] = pair[1];
				}
			}
			return qsobj;
		}
	},
	
	strip :
	function(args) {
		args = jQuery.extend({
			keys : '',
			win : window
			},
			args);
		
		if (jQuery.jqURL.url().indexOf('?') == -1) { // no query string found
			return jQuery.jqURL.url({ win:args.win });
		}
		// if no keys passed in, just return url with no querystring
		else if (!args.keys) {
			return jQuery.jqURL.url({ win:args.win }).split('?')[0];
		}
		else { //return stripped url

			var qsobj = jQuery.jqURL.qs({ ret:'object',win:args.win });  // object with key/value pairs		
			var counter = 0;
			var url = jQuery.jqURL.url({ win:args.win }).split('?')[0] + '?';
			var amp = '';
			
			for (var key in qsobj) {
				if (args.keys.indexOf(key) == -1) { 
					// pass test, add this key/value to string
					amp = (counter) ? '&' : '';
					url = url + amp + key + '=' + qsobj[key];
					counter++;
				}
			}
			return url;
		}			
	},
	
	get :
	function(key,args) {
		args = jQuery.extend({
			win : window
			},args);
	
	qsobj =  jQuery.jqURL.qs({ ret:'object', win:args.win });
	return qsobj[key];
	},
	
	set :
	function(hash,args) {
		args = jQuery.extend({
			win : window
			},args);
		
		// get current querystring
		var qsobj =  jQuery.jqURL.qs({ ret:'object',win:args.win });
		
		// add/set values from hash
		for (var i in hash) {
			qsobj[i] = hash[i];
		}
		
		var qstring = '';
		var counter = 0;
		var amp = '';
		
		// turn qsobj into string
		for (var k in qsobj) {
			amp = (counter) ? '&' : '';
			qstring = qstring + amp + k + '=' + qsobj[k];
			counter++;
		}
		return jQuery.jqURL.strip({ win: args.win }) + '?' + qstring;
	}
	
};

