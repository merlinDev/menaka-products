function loadItems() {

    var table = document.getElementById("table");
    table.innerHTML = null;

    var request = new XMLHttpRequest();
    request.onreadystatechange = function () {
        if (request.readyState === 4) {

            document.getElementById("load").style.cssText = "display:none;";
            document.getElementById("main-div").style.cssText = "display:block;";
            if (request.status === 200) {

                var cart_object_array = null;
                cart_object_array = JSON.parse(request.responseText);
                //alert(request.responseText);

                for (var i = 0; i < cart_object_array.length; i++) {
                    var cart_object = cart_object_array[i];

                    var tr = document.createElement("tr");

                    var td = document.createElement("td");
                    var div = document.createElement("div");
                    div.style.cssText = "background-image: url('" + cart_object.itemImg + "');width:40px;height:40px; background-size:cover";
                    td.appendChild(div);
                    var td0 = document.createElement("td");
                    td0.innerHTML = cart_object.itemName + "<br>" + "<small>(" + cart_object.type + ")</small>";

                    var td1 = document.createElement("td");
                    td1.innerHTML = cart_object.uPrice;

                    var td2 = document.createElement("td");
                    var qty = document.createElement("input");
                    qty.type = "number";
                    qty.style.cssText = "width:80px; padding: 0 5px 0 5px;";

                    if (cart_object.type === "loose item") {
                        qty.id = "looseQTY_" + cart_object.itemId;
                    } else if (cart_object.type === "spicy packet") {
                        td0.innerHTML += "<br><small> exp : " + cart_object.exp + "</small><br>" + "<small> man : " + cart_object.man + "</small>";
                        qty.id = "packetQTY_" + cart_object.itemId;
                    } else if (cart_object.type === "package") {
                        qty.id = "packageQTY_" + cart_object.itemId;
                    }
                    qty.value = cart_object.qty;
                    td2.appendChild(qty);

                    var kg = document.createElement("label");

                    if (cart_object.type === "loose item") {
                        kg.innerHTML = "&nbsp Kg. &nbsp";
                    } else {
                        kg.innerHTML = "&nbsp &nbsp &nbsp &nbsp &nbsp";
                    }
                    td2.appendChild(kg);

                    var update = document.createElement("button");
                    update.innerHTML = "update";
                    update.className = "btn btn-sm btn-outline-primary";
                    update.id = "update_" + cart_object.itemId;
                    update.setAttribute("onclick", "updateQty('" + cart_object.itemId + "','" + cart_object.type + "');");
                    td2.appendChild(update);

                    var td3 = document.createElement("td");
                    td3.innerHTML = cart_object.qtyPrice;

                    var td4 = document.createElement("td");
                    var remove = document.createElement("i");
                    remove.className = "typcn typcn-trash remove";
                    remove.setAttribute("onclick", "remove('" + cart_object.itemId + "','" + cart_object.type + "');");
                    td4.appendChild(remove);

                    tr.appendChild(td);
                    tr.appendChild(td0);
                    tr.appendChild(td1);
                    tr.appendChild(td2);
                    tr.appendChild(td3);
                    tr.appendChild(td4);

                    table.appendChild(tr);

                }
            } else {
                alert(request.responseText);
            }

            if (cart_object_array.length === 0) { // cart is empty
                var section = document.getElementById("cart-ui");
                section.innerHTML = null;
                section.innerHTML = "<h4>your cart is empty.<h4><br>";

                var btn1 = document.createElement("button");
                btn1.className = "btn btn-sm btn-secondary";
                btn1.innerHTML = "continue shopping";
                btn1.onclick = function () {
                    window.location = "products.jsp";
                };

                section.className = "empty-cart";
                section.appendChild(btn1);

                var note = document.getElementById("note");
                if (note !== null) {
                    note.style.display = "none";
                }

            }

        } else {
            document.getElementById("load").style.cssText = "display:block;";
            document.getElementById("main-div").style.cssText = "display:none;";
        }
    };
    request.open("GET", "showCart", false);
    request.send();
    showTotal();
}