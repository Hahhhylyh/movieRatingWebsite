import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet(name = "DelCommentServlet")
public class DelCommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movie_id = request.getParameter("mid");
        String user_id = request.getParameter("uid");

        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin");
            PreparedStatement stm =
                    conn.prepareStatement("delete from movie_user where movie_id = ? and user_id = ?");
            stm.setString(1, movie_id);
            stm.setString(2, user_id);
            stm.execute();

            response.sendRedirect("user_profile.jsp?uid=" + user_id);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
