import java.io.IOException;
import java.sql.*;

public class AddMovieServlet extends javax.servlet.http.HttpServlet {
    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
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

            // 1. movie table
            String sql_movie =
                    "insert into movie(movie_name, year, language, country, runtime, release_date, storyline, img, img_carousel)\n" +
                            "values(?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps_movie =
                    conn.prepareStatement(sql_movie, PreparedStatement.RETURN_GENERATED_KEYS);
            ps_movie.setString(1,title);
            ps_movie.setString(2,year);

            if(language.toLowerCase().equals("chinese")){
                ps_movie.setString(3,"1");
            }
            else if(language.toLowerCase().equals("english")){
                ps_movie.setString(3,"2");
            }
            else if(language.toLowerCase().equals("japanese")){
                ps_movie.setString(3,"3");
            }
            else{
                ps_movie.setString(3,"4");
            }

            ps_movie.setString(4,country);
            ps_movie.setString(5,runtime);
            ps_movie.setString(6,rd);
            ps_movie.setString(7,sl);
            ps_movie.setString(8,img);
            ps_movie.setString(9,img_c);

            ps_movie.execute();

            // 2. director table + movie_director
            
            ResultSet rs_movie_id = ps_movie.getGeneratedKeys();
            rs_movie_id.next();
            int movie_id = rs_movie_id.getInt(1);

            PreparedStatement ps_check_dir =
                    conn.prepareStatement("select * from director where director_name = ?");
            ps_check_dir.setString(1, director);

            ResultSet rs_dir_id_exist = ps_check_dir.executeQuery();

            int dir_id;
            if(!rs_dir_id_exist.next())
            {
                // new director
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
                // director already exist
                dir_id = rs_dir_id_exist.getInt("director_id");
            }
            // make linking in movie_director
            PreparedStatement ps_insert_fk_md =
                    conn.prepareStatement(
                            "insert into movie_director(movie_id, director_id) values(?,?)");
            ps_insert_fk_md.setInt(1, movie_id);
            ps_insert_fk_md.setInt(2, dir_id);
            ps_insert_fk_md.execute();


            // 3. actor table
            PreparedStatement ps_check_actor =
                    conn.prepareStatement("select * from actor where actor_name = ?");
            PreparedStatement ps_insert_actor =
                    conn.prepareStatement("insert into actor(actor_name) values(?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps_insert_fk_ma =
                    conn.prepareStatement(
                            "insert into movie_actor(movie_id, actor_id, actor_num) values(?,?,?)");
            for(int i = 0; i < actors.length; i++)
            {
                if(!actors[i].isEmpty())
                {
                    // input not empty
                    // check actor existed ?
                    ps_check_actor.setString(1, actors[i]);
                    ResultSet rs_actor_id_exist = ps_check_actor.executeQuery();
                    
                    int actor_id;
                    if(!rs_actor_id_exist.next())
                    {
                        // new actor
                        // insert into actor table first
                        ps_insert_actor.setString(1, actors[i]);
                        ps_insert_actor.execute();

                        ResultSet rs_actor_id_new = ps_insert_actor.getGeneratedKeys();
                        rs_actor_id_new.next();
                        actor_id = rs_actor_id_new.getInt(1);
                    }
                    else
                    {
                        // actor already existed
                        actor_id = rs_actor_id_exist.getInt("actor_id");
                    }
                    // make linking in movie_actor
                    ps_insert_fk_ma.setInt(1, movie_id);
                    ps_insert_fk_ma.setInt(2, actor_id);
                    ps_insert_fk_ma.setInt(3, i+1);
                    ps_insert_fk_ma.execute();
                }
                else
                {
                    // make linking in movie_actor
                    // add empty actor
                    ps_insert_fk_ma.setInt(1, movie_id);
                    ps_insert_fk_ma.setInt(2, i+1);
                    ps_insert_fk_ma.setInt(3, i+1);
                    ps_insert_fk_ma.execute();
                }
            }

            // 4. genre: insert movie_genre
            PreparedStatement ps_insert_fk_mg =
                    conn.prepareStatement("insert into movie_genre(movie_id, genre_id) values(?,?)");
            for(int i = 0; i < genres.length; i++)
            {
                if(!genres[i].isEmpty())
                {
                    // make linking in movie_genre
                    ps_insert_fk_mg.setInt(1, movie_id);
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

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {

    }
}
