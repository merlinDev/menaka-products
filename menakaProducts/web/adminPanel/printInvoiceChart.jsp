<%-- 
    Document   : printInvoiceChart
    Created on : Jun 24, 2018, 11:19:08 PM
    Author     : nipun
--%>

<%@page import="pojos.User"%>
<%@page import="pojos.Invoice"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include  file="AdminRestriction.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../style/css/bootstrap.min.css" rel="stylesheet">
        <title>JSP Page</title>
    </head>
    <body onload="getCharts();printInvoice();">

        <%
            Session s = NewHibernateUtil.getSessionFactory().openSession();

            List<Invoice> fullList = s.createCriteria(Invoice.class).add(Restrictions.eq("status", "closed")).list();
            int fullInvoices = fullList.size();
            int shopInvoices = 0;
            int localInvoices = 0;
        %>

    <center>
        <br>
        <br>
        <div style="width: 450px;">
            <canvas id="myChart" width="400" height="400"></canvas><br><br>
            <div class="sum" style="text-align: left;">
                <label> # of full invoices: <%=fullInvoices%> </label><br>
                <label> # of shop users invoices: <%=shopInvoices%> </label><br>
                <label> # of local users invoices: <%=localInvoices%> </label><br>
            </div>
        </div>
    </center>


    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="../style/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>            
    <script>

        function getCharts() {

            var request = new XMLHttpRequest();
            request.onreadystatechange = function () {
                if (request.readyState === 4 && request.status === 200) {
                    var values = JSON.parse(request.responseText);


                    var ctx = document.getElementById("myChart").getContext('2d');
                    var myChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"],
                            datasets: [{
                                    label: '# of invoices on this year',
                                    data: values,
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 1)',
                                        'rgba(54, 162, 235, 1)',
                                        'rgba(255, 206, 86, 1)',
                                        'rgba(75, 192, 192, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(153, 102, 255, 1)',
                                        'rgba(255, 159, 64, 1)'
                                    ]

                                }]
                        },
                        options: {
                            scales: {
                                yAxes: [{
                                        ticks: {
                                            beginAtZero: true
                                        }
                                    }]
                            }
                        }
                    });

                }
            };

            request.open("GET", "../GetCharts?type=invoices", true);
            request.send();
        }

        function printInvoice() {
            window.print();
        }

    </script>
</body>
</html>
