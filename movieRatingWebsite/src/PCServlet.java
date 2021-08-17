import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet(name = "PCServlet")
public class PCServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String uid = request.getParameter("uid");

        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin");
            String sql = "update users set status = ? where user_id = ?";
            PreparedStatement stm =
                    conn.prepareStatement(sql);
            stm.setString(1, action);
            stm.setString(2, uid);
            stm.execute();

            response.sendRedirect("admin.jsp");
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
