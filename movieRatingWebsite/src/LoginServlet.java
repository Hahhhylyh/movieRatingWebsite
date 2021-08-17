import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin"
                    );
            PreparedStatement stm =
                    conn.prepareStatement(
                            "select * from users where username = ? and password = ?");
            stm.setString(1, username);
            stm.setString(2, password);

            ResultSet rs = stm.executeQuery();
            if (rs.next())
            {
                if(rs.getInt("status") == 3) {
                    response.getWriter().println("<script type=\"text/javascript\">");
                    response.getWriter().println("alert('You are forbidden!');");
                    response.getWriter().println("location='login.jsp';");
                    response.getWriter().println("</script>");
                }
                else{
                    HttpSession session = request.getSession();

                    if(rs.getInt("status") == 2){
                        session.setAttribute("isAdmin", rs.getString("status"));
                    }
                    session.setAttribute("username", username);
                    session.setAttribute("uid", rs.getString("user_id"));

                    Cookie c_uid = new Cookie("c_uid", rs.getString("user_id"));
                    Cookie c_username = new Cookie("c_username", username);

                    response.addCookie(c_uid);
                    response.addCookie(c_username);

                    response.sendRedirect("index.jsp");
                }
            }
            else
            {
                //response.getWriter().println("<h1>Failed</h1>");
                response.getWriter().println("<script type=\"text/javascript\">");
                response.getWriter().println("alert('Username or password incorrect!');");
                response.getWriter().println("location='login.jsp';");
                response.getWriter().println("</script>");
            }
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
