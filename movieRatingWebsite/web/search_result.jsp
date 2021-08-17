<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
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
			color: white;
			cursor: pointer;
			border: none;
		}

		.header {
			font-family: SimHei;
			font-weight: bold;
			width: 1000px;
		}

		.movie_row {
			text-align: center;
			font-size: 1.05em;
		}

		ul {
			list-style-type: none;
		}

		li {
			width: 19%;
			display: inline-block;
		}

		a { color: #1588C8; }

		a:link, a:visited { text-decoration: none; }

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

	<%
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn =
				DriverManager.getConnection(
						"jdbc:mysql://localhost:3306/rating_website",
						"root", "admin");
		PreparedStatement ps =
				conn.prepareStatement("select m.movie_id, m.movie_name, m.img, avg(star)*2 as score\n" +
						"from movie as m left join movie_user as mu using(movie_id)\n" +
						"where movie_name like ?\n" +
						"group by movie_id");
		ps.setString(1, "%" + request.getParameter("search") + "%");
		ResultSet rs = ps.executeQuery();
		rs.last();
		int count = rs.getRow();
		rs.beforeFirst();
	%>
	<div class="header" style="margin: 20px auto; padding: 0 20px; width: 1200px; font-size: 2.0em; font-weight: 900; word-wrap: break-word;">
		Result of "<%=request.getParameter("search")%>"
		<em style="font-size: 0.5em;">[ <%=count%> Results found! ]</em>
	</div>

	<%
		if(count != 0)
		{
	%>
	<ul style="width: 1200px; margin: 0 auto;">
	<%
			while(rs.next())
			{
	%>
		<li>
			<div style="padding: 10px; margin-bottom: 10px;">
				<div style="text-align: center;">
					<a href="movie_profile.jsp?mid=<%=rs.getString("movie_id")%>">
						<img src="<%=rs.getString("img")%>" width="181.76px" height="251.66px">
					</a>
				</div>
				<table cellpadding="5px" width="100%" style="table-layout: fixed;">
					<tr>
						<td class="movie_row"><a href="movie_profile.jsp?mid=<%=rs.getString("movie_id")%>"><%=rs.getString("movie_name")%><strong> <%=String.format("%.1f", rs.getFloat("score"))%></strong></a></td>
					</tr>
				</table>
			</div>
		</li>
	<%
			}
	%>
	</ul>

	<%
		}
		if(count > 5)
		{
	%>

	<div style="bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
		Copyright 2017 - 2020, Xiamen University <br/>
		Bookman Development Team
	</div>

	<%
		}
		else
		{
	%>

	<div style="position: fixed; bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
		Copyright 2017 - 2020, Xiamen University <br/>
		Bookman Development Team
	</div>

	<%
		}
	%>

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