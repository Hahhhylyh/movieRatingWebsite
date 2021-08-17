import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(filterName = "HTMLFilter")
public class HTMLFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        String mid = req.getParameter("mid");
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        String link = "location='movie_profile.jsp?mid=" + mid + "';";

        if (title.contains("<") || title.contains(">"))
        {
            resp.getWriter().println("<script type=\"text/javascript\">");
            resp.getWriter().println("alert('Illegal chars!');");
            resp.getWriter().println(link);
            resp.getWriter().println("</script>");
        }
        else if (content.contains("<") || content.contains(">"))
        {
            resp.getWriter().println("<script type=\"text/javascript\">");
            resp.getWriter().println("alert('Illegal chars!');");
            resp.getWriter().println(link);
            resp.getWriter().println("</script>");
        }
        else
        {
            chain.doFilter(req, resp);
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
