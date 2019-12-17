function updateQty(id, type) {
    var newQty;

    if (type === "loose item") {
        newQty = document.getElementById("looseQTY_" + id);
    } else if (type === 'spicy packet') {
        newQty = document.getElementById("packetQTY_" + id);
    } else if (type === "package") {
        newQty = document.getElementById("packageQTY_" + id);
    }

    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {
            showAlert(request.responseText);
            setTimeout(function () {
                window.location = "viewCart.jsp";
            }, 1800);
        }
    };
    request.open("GET", "checkQty?id=" + id + "&type=" + type + "&qty=" + newQty.value, true);
    request.send();
}

function remove(id, type) {

    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {
            if (request.responseText === "removed@1") {
                window.location = "viewCart.jsp";

            }
        }
    };
    request.open("GET", "RemoveCartItem?id=" + id + "&type=" + type, true);
    request.send();
}

function checkout() {

    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {

            if (request.responseText === "LOGIN_0") {
                window.location = "login.jsp";
            } else if (request.responseText === "LOCATION_0") {
                window.location = "locations.jsp";
            } else if (request.responseText === "LOCATION_1") {
                window.location = "checkout.jsp";
            }
        }
    };

    request.open("GET", "checkout", true);
    request.send();

}

function showTotal() {

    var total = document.getElementById("total");

    var request = new XMLHttpRequest();
    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {
            console.log(request.responseText);
            total.innerHTML = request.responseText;
        }
    };
    request.open("GET", "GetTotal", false);
    request.send();
}

