import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PipedReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try
        {
            //?useUnicode=yes&characterEncoding=UTF-8 两边都utf8了, 好像不用
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin");
            PreparedStatement ps =
                    conn.prepareStatement("select * from users where username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if(rs.next())
            {
                // 1. Username existed
                response.getWriter().println("<script type=\"text/javascript\">");
                response.getWriter().println("alert('Username already exists! Please try another name.');");
                response.getWriter().println("location='register.jsp';");
                response.getWriter().println("</script>");
            }
            else
            {
                // 2. new username
                // insert users
                // session + cookies
                PreparedStatement ps_insert_users =
                        conn.prepareStatement("insert into users(username, password) values(?, ?)", PreparedStatement.RETURN_GENERATED_KEYS);
                ps_insert_users.setString(1, username);
                ps_insert_users.setString(2, password);
                ps_insert_users.execute();

                ResultSet rs_uid = ps_insert_users.getGeneratedKeys();
                rs_uid.next();
                String uid = rs_uid.getString(1);

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("uid", uid);

                Cookie c_uid = new Cookie("c_uid", uid);
                Cookie c_username = new Cookie("c_username", username);

                response.addCookie(c_uid);
                response.addCookie(c_username);

                response.sendRedirect("index.jsp");
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
