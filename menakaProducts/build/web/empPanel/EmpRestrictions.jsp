<%@page import="pojos.User"%>
<%

    User u = null;
    if (request.getSession().getAttribute("user") != null) {

        boolean ok = false;

        u = (User) request.getSession().getAttribute("user");
        if (u.getUsertype().getIdusertype() == 1 || u.getUsertype().getIdusertype() == 4) {
            ok = true;
            System.out.println("admin or emp");
        }else{
            System.out.println("restricted...........");
        }
        
        if (!ok) {
            response.sendRedirect("../userRestriction.html");
            return;
        }

    } else {
        response.sendRedirect("../index.jsp");
        return;
    }


%>