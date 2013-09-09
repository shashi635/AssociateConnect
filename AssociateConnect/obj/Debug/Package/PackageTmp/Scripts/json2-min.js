var JSON = { stringify: function stringify(a) {
    var g, e, b, f = "", d; switch (typeof a) {
        case "object": if (a) {
                if (a.constructor == Array) {
                    for (e = 0; e < a.length; ++e) {
                        d = stringify(a[e]);
                        if (f) { f += "," } f += d
                    }
                    return "[" + f + "]"
                } else {
                    if (typeof a.toString != "undefined") {
                        for (e in a) {
                            d = stringify(a[e]);
                            if (typeof d != "function") {
                                if (f) { f += "," } f += stringify(e) + ":" + d
                            } 
                        }
                        return "{" + f + "}"
                    } 
                }
            }
            return "null";
        case "number":
            return isFinite(a) ? String(a) : "null";
        case "string": b = a.length; f = '"';
            for (e = 0; e < b; e += 1) {
                g = a.charAt(e); if (g >= " ") { if (g == "\\" || g == '"') { f += "\\" } f += g } else {
                    switch (g) {
                        case "\b": f += "\\b"; break;
                        case "\f": f += "\\f"; break;
                        case "\n": f += "\\n"; break;
                        case "\r": f += "\\r"; break;
                        case "\t": f += "\\t";
                            break;
                        default: g = g.charCodeAt(); f += "\\u00" + Math.floor(g / 16).toString(16) + (g % 16).toString(16)
                    }
                }
            } return f + '"';
        case "boolean":
            return String(a);
        case "function":
            return a.toString(); default: return "null"
    }
}, parse: function (jsonString) {
    var js = jsonString;
    if (js.substr(0, 9) == "while(1);") 
    { js = js.substr(9) }
    if (js.substr(0, 2) == "/*") 
    { js = js.substr(2, js.length - 4) }
    return eval("(" + js + ")")
} 
};