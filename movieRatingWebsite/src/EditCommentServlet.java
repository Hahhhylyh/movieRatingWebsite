import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet(name = "EditCommentServlet")
public class EditCommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        //response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        String movie_id = request.getParameter("mid");
        String user_id = (String)session.getAttribute("uid");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String[] rates = request.getParameterValues("rate");

        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin");
            PreparedStatement ps =
                    conn.prepareStatement("update movie_user\n" +
                            "set \n" +
                            "\tstar = ?,\n" +
                            "    title = ?,\n" +
                            "    content = ?\n" +
                            "where movie_id = ? and user_id = ?");
            for(int i = 0; i < rates.length; i++)
            {
                if(!rates[i].isEmpty())
                    ps.setString(1, rates[i]);
            }
            ps.setString(2, title);
            ps.setString(3, content);
            ps.setString(4, movie_id);
            ps.setString(5, user_id);
            ps.execute();

            response.sendRedirect("movie_profile.jsp?mid=" + movie_id);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
