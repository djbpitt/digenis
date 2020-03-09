function requestsAreComplete(requests) {
    return requests.every(function (request) {
        return request.readyState == 4;
    });
}

function unsuccessfulRequests(requests) {
    var unsuccessful = requests.filter(function (request) {
        return request.status != 200;
    });
    return unsuccessful.length ? unsuccessful: null;
}

function onRequestsComplete(requests, callback) {
    // Wrap callback into a function that checks for all requests completion
    function sharedCallback() {
        if (requestsAreComplete(requests)) {
            callback(requests, unsuccessfulRequests(requests));
        }
    }
    
    // Assign the shared callback to each request's `onreadystatechange`
    requests.forEach(function (request) {
        request.onreadystatechange = sharedCallback;
    });
}

/* 
Based on http://stackoverflow.com/questions/34570205/without-jquery-how-can-javascript-check-that-multiple-ajax-calls-have-been-comp 

Call with:

onRequestsComplete([xmlhttp, xmlhttp2], function(requests, unsuccessful) {
    if (unsuccessful) { return; } // Abort if some requests failed

    document.getElementById("login_panel").innerHTML=requests[1].responseText;
    document.getElementById("login_panel_settings").innerHTML=requests[0].responseText;
});
 */