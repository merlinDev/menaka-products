<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="pojos.Interfaces"%>
<%@page import="pojos.User"%>
<%@page import="java.util.List"%>
<%@page import="pojos.Privilage"%>
<%@page import="org.hibernate.Session"%>
<%@page import="connection.NewHibernateUtil"%>
<%
    
    String uri = request.getRequestURI();
    String currentPage = uri.substring(uri.lastIndexOf("/") + 1);
    
    System.out.println(currentPage);
    System.out.println(currentPage);
    System.out.println(currentPage);
    System.out.println(currentPage);
    
    Session s = NewHibernateUtil.getSessionFactory().openSession();
    
    User user = (User) request.getSession().getAttribute("user");
    
    Interfaces requestPage = (Interfaces) s.createCriteria(Interfaces.class)
            .add(Restrictions.eq("iterfaceName", currentPage)).uniqueResult();
    
    List<Privilage> privilages = s.createCriteria(Privilage.class)
            .add(Restrictions.eq("interfaces", requestPage))
            .list();
    
    boolean granted = false;
    
    for (Privilage privilage : privilages) {
        if (privilage.getUsertype().getIdusertype().equals(user.getUsertype())) {  // usr can go into the page
            granted = true;
            break;
        }
    }
    
    if (granted == false) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
    
%>