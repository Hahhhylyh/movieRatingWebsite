import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@MultipartConfig

@WebServlet(name = "EditUserProfileServlet")
public class EditUserProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        if(request.getParameter("doWhat").equals("picture"))
        {
            // upload picture
            InputStream is =
                    request.getPart("avatar").getInputStream();
            byte[] buffer = new byte[100 * 1024 * 1024];
            int len_image = is.read(buffer);
            String path = session.getServletContext().getRealPath("/" + session.getAttribute("uid") + ".png");
            OutputStream os = new FileOutputStream(path);
            os.write(buffer, 0, len_image);
            os.flush();
            os.close();

            //response.getWriter().println("upload picture");
            response.sendRedirect("user_profile.jsp?uid=" + session.getAttribute("uid"));
        }
        else if(request.getParameter("doWhat").equals("info"))
        {
            // update information
            String gender = request.getParameter("gender");
            String dob = request.getParameter("dob");
            String email = request.getParameter("email");
            String location = request.getParameter("location");
            String quote = request.getParameter("quote");

            try
            {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn =
                        DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/rating_website",
                                "root", "admin");
                PreparedStatement ps =
                        conn.prepareStatement("update users\n" +
                                "set\n" +
                                "\tgender = ?,\n" +
                                "    dob = ?,\n" +
                                "    email = ?,\n" +
                                "    location = ?,\n" +
                                "    quote = ?\n" +
                                "where user_id = ?");

                if(gender.toLowerCase().equals("male")){
                    ps.setString(1,"1");
                }
                else if(gender.toLowerCase().equals("female")){
                    ps.setString(1,"2");
                }
                else{
                    ps.setString(1,null);
                }
                ps.setString(2, dob);
                ps.setString(3, email);
                ps.setString(4, location);
                ps.setString(5, quote);
                ps.setString(6, (String)session.getAttribute("uid"));

                ps.execute();

                //response.getWriter().println("update information");
                response.sendRedirect("user_profile.jsp?uid=" + session.getAttribute("uid"));
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
