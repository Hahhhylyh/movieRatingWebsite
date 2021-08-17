<%@ page import="java.sql.*" %>
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
			color: #E09015;
			font-size: 1.1em;
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
			color: #4CAF50;
			cursor: pointer;
			border: none;
		}

		.movie-container {
			padding: 10px;
			margin-bottom: 10px;
			text-align: center;
			font-size: 1.05em;
		}

		.movie-container a { color: #1588C8; }
		.movie-container a:link, a:visited { text-decoration: none; }
		.movie-container a:hover { opacity: 0.7; }

		.checked {
			color: orange;
		}

		ul {
			list-style-type: none;
		}

		li {
			width: 19%;
			display: inline-block;
		}

		dl { font-size: 1.2em; }

		dt { 
			float: left;
			padding-right: 20px;
			color: silver;
			font-weight: bold;
		}

		dd a {
			padding: 3px 6px;
			margin-right: 5px;
			color: black;
			text-decoration: none;
		}

		dd a:hover, a.selected {
			background-color: silver;
			color: white;
		}

		a { text-decoration: none; color: inherit;}
		a:hover { text-decoration: none; color: inherit;}
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

	<div style="margin: 20px auto; width: 1200px;">
		<div style="font-family: SimHei; font-size: 3.0em; font-weight: 900;  padding: 20px 60px; border-bottom: 1.2px dashed silver;">Sorting</div>
		<div style="padding: 0px 60px">
			<%
				String gid = request.getParameter("genre");
				String lid = request.getParameter("language");
				String sid = request.getParameter("sorting");
			%>
			<dl>
				<dt>Genre:</dt>
				<dd>
					<a href="sorting_page.jsp?genre=0&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("0")) {%> selected <%}%>" >All</a>
					<a href="sorting_page.jsp?genre=1&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("1")) {%> selected <%}%>" >Action</a>
					<a href="sorting_page.jsp?genre=2&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("2")) {%> selected <%}%>" >Adventure</a>
					<a href="sorting_page.jsp?genre=3&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("3")) {%> selected <%}%>" >Animation</a>
					<a href="sorting_page.jsp?genre=4&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("4")) {%> selected <%}%>" >Comedy</a>
					<a href="sorting_page.jsp?genre=5&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("5")) {%> selected <%}%>" >Crime</a>
					<a href="sorting_page.jsp?genre=10&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("10")) {%> selected <%}%>" >Drama</a>
					<a href="sorting_page.jsp?genre=6&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("6")) {%> selected <%}%>" >Horror</a>
					<a href="sorting_page.jsp?genre=7&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("7")) {%> selected <%}%>" >Romance</a>
					<a href="sorting_page.jsp?genre=8&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("8")) {%> selected <%}%>" >Sport</a>
					<a href="sorting_page.jsp?genre=9&language=<%=lid%>&sorting=<%=sid%>" class="<%if(gid.equals("9")) {%> selected <%}%>" >Thriller</a>
				</dd>
			</dl>
			<dl>
				<dt>Language:</dt>
				<dd>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=0&sorting=<%=sid%>" class="<%if(lid.equals("0")) {%> selected <%}%>" >All</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=1&sorting=<%=sid%>" class="<%if(lid.equals("1")) {%> selected <%}%>" >Chinese</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=2&sorting=<%=sid%>" class="<%if(lid.equals("2")) {%> selected <%}%>" >English</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=3&sorting=<%=sid%>" class="<%if(lid.equals("3")) {%> selected <%}%>" >Japanese</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=4&sorting=<%=sid%>" class="<%if(lid.equals("4")) {%> selected <%}%>" >Other</a>
				</dd>
			</dl>
			<dl>
				<dt>Sort by:</dt>
				<dd>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=<%=lid%>&sorting=0" class="<%if(sid.equals("0")) {%> selected <%}%>" >Time</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=<%=lid%>&sorting=1" class="<%if(sid.equals("1")) {%> selected <%}%>" >Comment</a>
					<a href="sorting_page.jsp?genre=<%=gid%>&language=<%=lid%>&sorting=2" class="<%if(sid.equals("2")) {%> selected <%}%>" >Rating</a>
				</dd>
			</dl>
		</div>

		<ul style="width: 1200px; margin: 0 auto;">
			<%
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn =
						DriverManager.getConnection(
								"jdbc:mysql://localhost:3306/rating_website",
								"root", "admin");
				Statement stm = conn.createStatement();

				String GENRE, LANGUAGE, SORT;
				if(gid.equals("0"))
					GENRE = "where genre_id = genre_id";
				else
					GENRE = "where genre_id = " + gid;

				if(lid.equals("0"))
					LANGUAGE = "where language = language";
				else
					LANGUAGE = "where language = " + lid;

				if(sid.equals("0"))
					SORT = "order by m.last_modified desc";
				else if(sid.equals("1"))
					SORT = "order by num_comment desc";
				else
					SORT = "order by score desc";

				String sql = "select m.movie_id, m.movie_name, m.img, m.last_modified, avg(star)*2 as score, count(user_id) as num_comment\n" +
								"from \n" +
								"(select *\n" +
								"from movie join movie_genre using(movie_id) join genre using(genre_id)\n" +
								GENRE + ") as m left join movie_user as mu using(movie_id)\n" +
								LANGUAGE + "\n" +
								"group by movie_id\n" +
								SORT;
				ResultSet rs = stm.executeQuery(sql);
				while(rs.next())
				{
			%>
			<li>
				<div class="movie-container">
					<div style="text-align: center;">
						<a href="movie_profile.jsp?mid=<%=rs.getString("movie_id")%>">
							<img src="<%=rs.getString("img")%>" width="181.76px" height="251.66px">
						</a>
					</div>
					<table cellpadding="5px" width="100%" style="table-layout: fixed;">
						<tr>
							<td><a href="movie_profile.jsp?mid=<%=rs.getString("movie_id")%>"><%=rs.getString("movie_name")%><strong> <%=String.format("%.1f",rs.getFloat("score"))%></strong></a></td>
						</tr>
					</table>
				</div>
			</li>
			<%
				}
			%>
		</ul>
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