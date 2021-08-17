<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	if (session.getAttribute("username") == null)
		response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	<!-- CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<style type="text/css">
		.nav_item
		{
			display: inline-block;
			font-size: 26px;
			font-weight: bold;
			padding: 15px 5px;
		}

		* { box-sizing: border-box; }

		body { 
			font-family: Tahoma, Verdana, Arial, sans-serif;
			background-color:  white;
			color: black;
		}

		strong {
			color: #e09015;
		}

		.btn {
			background: transparent;
			color: black;
			border: none;
			padding: 6px;
  			font-size: 26px;
  			font-family: "Courier New", "KaiTi", monospace;
  			font-weight: bold;
			cursor: pointer;
		}

		.btn:hover {
			background-color: #EEEEEE;
		}

		.dropdown {
			display: inline-block;
			font-size: 26px;
			font-weight: bold;
			padding: 10px;
		}

		.dropdown-content {
		  	display: none;
		  	position: absolute;
		  	background-color: #f9f9f9;
		  	min-width: 160px;
		  	box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		  	z-index: 1;
		  	font-size: 18px;
		  	font-family: "Courier New", Courier, monospace;
		  	font-weight: normal;
		}

		.dropdown-content a {
		  	float: none;
		  	color: black;
		  	padding: 12px 16px;
		  	text-decoration: none;
		  	display: block;
		  	text-align: left;
		}

		.dropdown-content a:hover {
		  	background-color: #DDDDDD;
		}

		.dropdown:hover .dropdown-content {
			display: block;
		}

		.text-overflow-ellipsis {
		  border: 1px solid black;
		  padding: 10px;
		  width: 250px;
		  overflow: hidden;
		  text-overflow: ellipsis;
		  white-space: nowrap;
		}

		#topBtn {
			display: none;
			position: fixed;
			bottom: 25px;
			right: 30px;
			z-index: 99;
			font-size: 40px;
			background-color: transparent;
			color: white;
			cursor: pointer;
			border: none;
		}

		.header {
			font-family: SimHei;
			font-weight: bold;
			width: 800px;
		}

		.checked {
			color: orange;
		}

		.bar-5 {width: 4%; height: 18px; background-color: #4CAF50;}
		.bar-4 {width: 60%; height: 18px; background-color: #2196F3;}
		.bar-3 {width: 21%; height: 18px; background-color: #00bcd4;}
		.bar-2 {width: 10%; height: 18px; background-color: #ff9800;}
		.bar-1 {width: 5%; height: 18px; background-color: #f44336;}

		.bar-container {
			width: 100%;
		}

		/* Taken from (the star input): https://codepen.io/hesguru/pen/BaybqXv */

		.rate {
		    float: left;
		    height: 46px;
		    padding: 0 10px;
		}
		.rate:not(:checked) > input {
		    position:absolute;
		    top:-9999px;
		}
		.rate:not(:checked) > label {
		    float:right;
		    width:1em;
		    overflow:hidden;
		    white-space:nowrap;
		    cursor:pointer;
		    font-size:30px;
		    color:#ccc;
		}
		.rate:not(:checked) > label:before {
		    content: '★ ';
		}
		.rate > input:checked ~ label {
		    color: #ffc700;    
		}
		.rate:not(:checked) > label:hover,
		.rate:not(:checked) > label:hover ~ label {
		    color: #deb217;  
		}
		.rate > input:checked + label:hover,
		.rate > input:checked + label:hover ~ label,
		.rate > input:checked ~ label:hover,
		.rate > input:checked ~ label:hover ~ label,
		.rate > label:hover ~ input:checked ~ label {
		    color: #c59b08;
		}

		.myInput {
			width: 200px;
			padding: 5px;
			letter-spacing: 0.1em;
		}

		a { text-decoration: none;}
		a:hover { opacity: 0.7; }
	</style>
</head>
<body>
	<div style="margin: 0 auto; width: 1200px;">
		<div style="display: inline-block;">
			<div class="nav_item">
				<a href="index.jsp"><button class="btn" id="home"><i class="fa fa-home"></i> Home</button></a>
			</div>
			<div class="dropdown">
				<button class="btn" id="dmenu"><i class="fa fa-bars"></i> Menu</button>
				<div class="dropdown-content">
					<%
						if(session.getAttribute("isAdmin") != null)
						{
					%>
					<a href="add_movie.jsp">Add Movie</a>
					<a href="admin.jsp">Manage Users</a>
					<%
						}
					%>
					<a href="sorting_page.jsp?genre=0&language=0&sorting=0">Movie Sorting</a>
				</div>
			</div>
			<div style="display: inline-block; margin-left: 20px">
				<form method="get" action="search_result.jsp">
					<input type="text" placeholder="Search.." name="search" style="font-size: 20px; padding:6px; border: none; text-indent: 10px; width: 550px;">
					<button type="submit" style="position: absolute; overflow:hidden; background: white; border: none; cursor: pointer;"><i class="fa fa-search" style="margin:6.6px; font-size: 20px;"></i></button>
				</form>
			</div>
		</div>
		<div style="float: right; width: 300px;">
			<div class="nav_item" style="width: 250px; text-align: center;">
				<a href="user_profile.jsp?uid=<%=session.getAttribute("uid")%>"> <button class="btn" id="user" style="width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 24px;"><i class="fa fa-user"></i> <%=session.getAttribute("username")%></button> </a>
			</div>
			<div class="nav_item" style="float: right;">
				<a href="LogoutServlet"> <button class="btn"><i class="fa fa-sign-out" aria-hidden="true"></i></button></a>
			</div>
		</div>
	</div>

	<div style="margin: 30px auto; width: 1000px;">
		<div class="header" style="margin: 30px auto 50px auto; font-size: 3.0em; text-align: center;">
			Movie Management Page
		</div>
		<div class="header" style="width: 1000px; font-size: 1.6em; text-align: center;">
			Edit Movie Details
		</div>
		<%
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn =
					DriverManager.getConnection(
							"jdbc:mysql://localhost:3306/rating_website",
							"root", "admin");
			Statement stm =
					conn.createStatement();
			String sql = "select * from movie join movie_director using (movie_id) join director using (director_id) where movie_id = " + request.getParameter("mid");
			ResultSet rs = stm.executeQuery(sql);
			rs.next();
		%>
		<form method="post" action="EditMovieServlet">
			<input type="hidden" name="mid" value="<%=request.getParameter("mid")%>" />
			<table width="100%">
				<tr>
					<td colspan="3" style="text-align: center; padding: 20px;">
						<input type="text" class="myInput" name="title" value="<%=rs.getString("movie_name")%>" style="width: 600px;" required/>
					</td>
				</tr>
				<tr>
					<td width="40%" style="padding: 0 30px 20px 10px;">
						<div style="margin: 0 auto; text-align: left;">
							<table cellpadding="5px" style="text-align: left;">
								<tr>
									<th>Director: </th>
									<td><input type="text" name="director" value="<%=rs.getString("director_name")%>" class="myInput" required/></td>
								</tr>
								<%
									Statement stm_actor =
											conn.createStatement();
									String sql_actor = "select actor_name\n" +
											"from movie_actor join actor using(actor_id)\n" +
											"where movie_id = " + request.getParameter("mid") + "\n" +
											"order by actor_num";
									ResultSet rs_actor = stm_actor.executeQuery(sql_actor);
									int count = 0;
									while(rs_actor.next())
									{
										count++;
								%>
								<tr>
									<th>Main actor <%=count%>: </th>
									<td><input type="text" name="actor" value="<%=rs_actor.getString("actor_name")%>" class="myInput" required/></td>
								</tr>
								<%
									}
								%>
								<tr>
									<th>Country: </th>
									<td><input type="text" name="country" value="<%=rs.getString("country")%>" class="myInput" required/></td>
								</tr>
							</table>
						</div>
					</td>
					<td width="20%" style="padding: 0 30px 20px 10px;">
						<label for="genre">Genre:</label>
						<%
							Statement stm_genre =
									conn.createStatement();
							String sql_genre = "select *\n" +
									"from movie_genre\n" +
									"where movie_id = " + request.getParameter("mid");
							ResultSet rs_genre = stm_genre.executeQuery(sql_genre);
							ArrayList<Integer> gids = new ArrayList<>();
							while(rs_genre.next())
							{
								gids.add(rs_genre.getInt("genre_id"));
							}
						%>
						<select id="genre" name="genre" multiple size="10" required>
							<option value="1" <%if(gids.contains(1)) {%> selected <%}%> >Action</option>
							<option value="2" <%if(gids.contains(2)) {%> selected <%}%> >Adventure</option>
							<option value="3" <%if(gids.contains(3)) {%> selected <%}%> >Animation</option>
							<option value="4" <%if(gids.contains(4)) {%> selected <%}%> >Comedy</option>
							<option value="5" <%if(gids.contains(5)) {%> selected <%}%> >Crime</option>
							<option value="10" <%if(gids.contains(10)) {%> selected <%}%> >Drama</option>
							<option value="6" <%if(gids.contains(6)) {%> selected <%}%> >Horror</option>
							<option value="7" <%if(gids.contains(7)) {%> selected <%}%> >Romance</option>
							<option value="8" <%if(gids.contains(8)) {%> selected <%}%> >Sport</option>
							<option value="9" <%if(gids.contains(9)) {%> selected <%}%> >Thriller</option>
						</select>
					</td>
					<td width="40%" style="padding: 0 30px 20px 10px;">
						<table cellpadding="5px" style="text-align: left;">
							<tr>
								<th>Year: </th>
								<td><input type="text" name="year" value="<%=rs.getString("year")%>" class="myInput" required /></td>
							</tr>
							<tr>
								<th>Language: </th>
								<%
									String lang;
									if(rs.getInt("language") == 1)
										lang = "Chinese";
									else if(rs.getInt("language") == 2)
										lang = "English";
									else if(rs.getInt("language") == 3)
										lang = "Japanese";
									else
										lang = "Others";
								%>
								<td><input type="text" name="language" value="<%=lang%>" class="myInput" required /></td>
							</tr>							
							<tr>
								<th>Runtime: </th>
								<td><input type="text" name="runtime" value="<%=rs.getString("runtime")%>" class="myInput" required /></td>
							</tr>
							<tr>
								<th>Release date: </th>
								<td><input type="text" name="release_date" value="<%=rs.getString("release_date")%>" class="myInput" required /></td>
							</tr>
							<tr>
								<th>Image: </th>
								<td><input type="text" name="image" value="<%=rs.getString("img")%>" class="myInput" required /></td>
							</tr>
							<tr>
								<th>Image Carousel: </th>
								<td><input type="text" name="image_carousel" value="<%=rs.getString("img_carousel")%>" class="myInput" required /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="text-align: center; padding: 20px;">
						<textarea class="myInput" style="height:8em; width: 800px;" name="storyline" required><%=rs.getString("storyline")%></textarea>
					</td>
				</tr>
				<tr>
					<th></th>
					<td style="text-align: right; padding-right: 37px;"> 
						<input type="submit" style="margin-right: 10px;" />
						<input type="Reset" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div style="bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
		Copyright 2017 - 2020, Xiamen University <br/>
		Bookman Development Team
	</div>

	<button id="topBtn"><a href="#"><i class="fa fa-chevron-circle-up"></a></i></button>

	<script type="text/javascript">
		//Get the button
		var mybutton = document.getElementById("topBtn");
		console.log(mybutton);

		// When the user scrolls down 20px from the top of the document, show the button
		window.onscroll = function() {scrollFunction()};

		function scrollFunction() {
		  	if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		    	mybutton.style.display = "block";
		  	} else {
		    	mybutton.style.display = "none";
		  	}
		}
	</script>
</body>
</html>