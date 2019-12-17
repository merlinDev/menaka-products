var response;
function sendRequest(page, method, bind) {
    var request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === 4) {
            if (request.status === 200) {
                // request and respond successfull.
                response = request.responseText;
                alert(response);
            }
        }
    };

    if (method === "GET") {
        // http request using get method
        request.open("GET", page + "?" + bind, true);
        request.send();
    } else if (method === "POST") {
        // http request using post method
        request.open("POST", page, true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        request.send(bind);
    }else if ("FORM"){
        
    }
    return response;
}
