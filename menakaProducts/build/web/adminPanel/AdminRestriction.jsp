<%@page import="pojos.User"%>
<%

    User u = null;
    if (request.getSession().getAttribute("user") != null) {
        u = (User) request.getSession().getAttribute("user");
        if (u.getUsertype().getIdusertype() != 1) {
            response.sendRedirect("../userRestriction.html");
            return;
        }
    } else {
        response.sendRedirect("../index.jsp");
        return;
    }

%>