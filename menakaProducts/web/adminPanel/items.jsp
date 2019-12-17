
<%@page import="pojos.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="../style/bootstrap.css" rel="stylesheet">
        <link href="../style/style.css" rel="stylesheet">
        <link href="../style/media.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css?family=Poiret+One" rel="stylesheet">
        <title>JSP Page</title>

        <style type="text/css">
            .field{
                padding: 5px;
                min-width: 250px;
                min-height: 30px;
                margin-top: 10px;
            }
            .description{
                min-width: 250px;
                min-height: 100px;
                max-height: 100px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body onload="loadData();">

        <div class="container-fluid">
            <div class="row">
                <div  class="col-sm-12">

                    <input class="textField" id="keyword" type="text" placeholder="search" onkeyup="loadData();">
                    <br><br>

                    <div class="table-responsive">

                        <table class="table">
                            <thead class="thead-dark">
                                <tr>
                                    <th>#</th>
                                    <th>product name</th>
                                    <th>unit price (rs)</th>
                                    <th>available qty.</th>
                                </tr>
                            </thead>
                            <tbody id="table">

                            </tbody>
                        </table>

                    </div>
                    <br><br>
                    <!-- end table -->
                </div>

                <div class="col-sm-3">
                    <div style="width: 10px; height: 10px; background-color: #fab1a0"></div> Not available.
                    <br><br>
                    <button style="width: 200px" onclick="addProduct();" class="btn btn-primary"> add another product. </button>
                    <br><br>
                    <button style="width: 200px" class="btn btn-primary"> add a category. </button>
                </div>

                <div id="changeDiv" class="col-sm-6">
                    <!-- load fields here -->

                </div>

                <!-- endd of first row-->
            </div>
        </div>

        <script type="text/javascript">

            function loadData() {
                var keyword = document.getElementById("keyword").value;
                var request = new XMLHttpRequest();
                request.onreadystatechange = function () {
                    if (request.readyState === 4 && request.status === 200) {
                        document.getElementById("table").innerHTML = null;

                        var item_object_array = JSON.parse(request.responseText);
                        for (var i = 0; i < item_object_array.length; i++) {
                            var item_object = item_object_array[i];

                            var tr = document.createElement("tr");

                            if (item_object.status === 0) {
                                tr.style.cssText = "background-color: #fab1a0";
                            }

                            var td1 = document.createElement("td");
                            td1.innerHTML = item_object.id;

                            var td2 = document.createElement("td");
                            td2.innerHTML = item_object.name;

                            var td3 = document.createElement("td");
                            td3.innerHTML = item_object.uPrice;

                            var td4 = document.createElement("td");
                            td4.innerHTML = item_object.qty;

                            tr.appendChild(td1);
                            tr.appendChild(td2);
                            tr.appendChild(td3);
                            tr.appendChild(td4);

                            document.getElementById("table").appendChild(tr);

                        }
                    }
                };
                request.open("GET", "../searchProduct?key=" + keyword, true);
                request.send();

            }
            var load = true;
            function addProduct() {
                if (load) {
                    var frame = document.getElementById("frame");
                    frame.src = "addItem.jsp";
                    frame.cssText = "display: anything";
                }

            }
        </script>

    </body>
</html>
