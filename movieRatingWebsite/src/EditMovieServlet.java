import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "EditMovieServlet")
public class EditMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String year = request.getParameter("year");
        String country = request.getParameter("country");
        String language = request.getParameter("language");
        String runtime = request.getParameter("runtime");
        String rd = request.getParameter("release_date");
        String img = request.getParameter("image");
        String img_c = request.getParameter("image_carousel");
        String sl = request.getParameter("storyline");

        String director = request.getParameter("director");

        String[] actors = request.getParameterValues("actor");

        String[] genres = request.getParameterValues("genre");

        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/rating_website",
                            "root", "admin");

            // 1. update movie table
            String sql =
                    "update movie\n" +
                            "set \n" +
                            "\tmovie_name = ?,\n" +
                            "    year = ?,\n" +
                            "\tlanguage = ?,\n" +
                            "    country = ?,\n" +
                            "    runtime = ?,\n" +
                            "    release_date = ?,\n" +
                            "    storyline = ?,\n" +
                            "    img = ?,\n" +
                            "    img_carousel = ?\n" +
                            "where movie_id = ?";
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, year);

            if(language.toLowerCase().equals("chinese")){
                ps.setString(3,"1");
            }
            else if(language.toLowerCase().equals("english")){
                ps.setString(3,"2");
            }
            else if(language.toLowerCase().equals("japanese")){
                ps.setString(3,"3");
            }
            else{
                ps.setString(3,"4");
            }

            ps.setString(4, country);
            ps.setString(5, runtime);
            ps.setString(6, rd);
            ps.setString(7, sl);
            ps.setString(8, img);
            ps.setString(9, img_c);
            ps.setString(10, request.getParameter("mid"));

            ps.execute();

            // 2. update director
            PreparedStatement ps_check_dir =
                    conn.prepareStatement("select * from director where director_name = ?");
            ps_check_dir.setString(1, director);

            ResultSet rs_dir_id_exist = ps_check_dir.executeQuery();

            int dir_id;
            if(!rs_dir_id_exist.next())
            {
                // 2.1 new director
                // insert into director table first
                PreparedStatement ps_insert_dir =
                        conn.prepareStatement("insert into director(director_name) values(?)", PreparedStatement.RETURN_GENERATED_KEYS);
                ps_insert_dir.setString(1, director);
                ps_insert_dir.execute();

                ResultSet rs_dir_id_new = ps_insert_dir.getGeneratedKeys();
                rs_dir_id_new.next();
                dir_id = rs_dir_id_new.getInt(1);
            }
            else
            {
                // 2.2 director already exist
                dir_id = rs_dir_id_exist.getInt("director_id");
            }
            // make linking in movie_director
            PreparedStatement ps_insert_fk_md =
                    conn.prepareStatement(
                            "update movie_director\n" +
                                    "set director_id = ?\n" +
                                    "where movie_id = ?");
            ps_insert_fk_md.setInt(1, dir_id);
            ps_insert_fk_md.setString(2, request.getParameter("mid"));
            ps_insert_fk_md.execute();

            // 3. update actor
            PreparedStatement ps_check_actor =
                    conn.prepareStatement("select * from actor where actor_name = ?");
            PreparedStatement ps_insert_actor =
                    conn.prepareStatement("insert into actor(actor_name) values(?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps_update_fk_ma =
                    conn.prepareStatement(
                            "update movie_actor\n" +
                                    "set actor_id = ?\n" +
                                    "where movie_id = ? and actor_num = ?");
            for(int i = 0; i < actors.length; i++)
            {
                if(!actors[i].isEmpty())
                {
                    // 3.1 input not empty
                    // check actor existed ?
                    ps_check_actor.setString(1, actors[i]);
                    ResultSet rs_actor_id_exist = ps_check_actor.executeQuery();

                    int actor_id;
                    if(!rs_actor_id_exist.next())
                    {
                        // 3.1.1 new actor
                        // insert into actor table first
                        ps_insert_actor.setString(1, actors[i]);
                        ps_insert_actor.execute();

                        ResultSet rs_actor_id_new = ps_insert_actor.getGeneratedKeys();
                        rs_actor_id_new.next();
                        actor_id = rs_actor_id_new.getInt(1);
                    }
                    else
                    {
                        // 3.1.2 actor already existed
                        actor_id = rs_actor_id_exist.getInt("actor_id");
                    }
                    // make linking in movie_actor
                    ps_update_fk_ma.setInt(1, actor_id);
                    ps_update_fk_ma.setString(2, request.getParameter("mid"));
                    ps_update_fk_ma.setInt(3, i+1);
                    ps_update_fk_ma.execute();
                }
                else
                {
                    // 3.2 input empty
                    // make linking in movie_actor
                    // foreign key with its num
                    ps_update_fk_ma.setInt(1, i+1);
                    ps_update_fk_ma.setString(2, request.getParameter("mid"));
                    ps_update_fk_ma.setInt(3, i+1);
                    ps_update_fk_ma.execute();
                }
            }

            // 4. update genre
            // delete all genre first
            PreparedStatement ps_del_genre =
                    conn.prepareStatement("delete from movie_genre\n" +
                            "where movie_id = ?");
            ps_del_genre.setString(1, request.getParameter("mid"));
            ps_del_genre.execute();

            // insert back
            PreparedStatement ps_insert_fk_mg =
                    conn.prepareStatement("insert into movie_genre(movie_id, genre_id) values(?,?)");
            for(int i = 0; i < genres.length; i++)
            {
                if(!genres[i].isEmpty())
                {
                    // make linking in movie_genre
                    ps_insert_fk_mg.setString(1, request.getParameter("mid"));
                    ps_insert_fk_mg.setString(2, genres[i]);
                    ps_insert_fk_mg.execute();
                }
            }

            response.sendRedirect("add_movie.jsp");
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
