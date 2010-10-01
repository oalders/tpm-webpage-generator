var last="";
var rot13map;

function rot13init() {

    var map = new Array();
    var s   = "abcdefghijklmnopqrstuvwxyz";
  
    for (i=0; i<s.length; i++)
        map[s.charAt(i)]               = s.charAt((i+13)%26);

    for (i=0; i<s.length; i++)
        map[s.charAt(i).toUpperCase()] = s.charAt((i+13)%26).toUpperCase();

    return map;
}

function rot13(a) {

    if (!rot13map)
        rot13map=rot13init();

    s = "";
    for (i=0; i<a.length; i++) {
        var b = a.charAt(i);

        s += (b>='A' && b<='Z' || b>='a' && b<='z' ? rot13map[b] : b);
    }
    return s;
}

function mailto_link(eaddress, domain, subject, tagline) {

    document.write("<a href=mailto:", rot13(eaddress), '@', rot13(domain), subject,">", tagline, "</a>");

}
