<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="javax.swing.plaf.nimbus.State" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: CBY
  Date: 6/16/2020
  Time: 1:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
  </head>
  <body>
    <%
      Class.forName("com.mysql.jdbc.Driver");
      Connection conn =
              DriverManager.getConnection(
                      "jdbc:mysql://localhost/rating_website",
                      "root", "admin");
      Statement stm =
              conn.createStatement();
      String sql = "select * from movie";
      ResultSet rs = stm.executeQuery(sql);

      while (rs.next())
      {
    %>
      <div>
        <%=rs.getString("movie_name")%>:<%=rs.getString("year")%>
      </div>
    <%
      }
    %>
  </body>
</html>
