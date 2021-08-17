<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.swing.plaf.nimbus.State" %>
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

		.link-button {
		  font: inherit;
		  background: none;
		}

		.item5 {
			margin: 10px auto 20px auto;
			text-align: center;
			width:175px; 
			word-wrap: break-word;
			font-family: Verdana, "Microsoft YaHei", serif;
			font-size: 16px;
			cursor: pointer;
		}

		.movie_container {
			position: relative;
			font-family: Comic Sans MS;
		}

		.movie_caption {
			position: absolute; 
			top: 20px;
			left: 20px;
			right:20px;
			background-color: black;
			color: white;
			padding: 20px;
			opacity: 0.9;
			font-size: 20px;
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

		.movie_properties {
			font-size: 16px;
			font-family: Arial, Helvetica, sans-serif;
		}

		.movie_properties th {
			text-align: left;
			vertical-align: top;
			width: 125px;
			color: #666666;
		}

		.header {
			font-family: SimHei;
			font-weight: bold;
			width: 1000px;
		}

		.checked {
			color: orange;
		}

		.bar-5 {width: 100%; height: 18px; background-color: #4CAF50;}
		.bar-4 {width: 100%; height: 18px; background-color: #2196F3;}
		.bar-3 {width: 100%; height: 18px; background-color: #00bcd4;}
		.bar-2 {width: 100%; height: 18px; background-color: #ff9800;}
		.bar-1 {width: 100%; height: 18px; background-color: #f44336;}

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
		    position: fixed;
			opacity: 0;
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

		a { text-decoration: none; color: hotpink}

		a:link, a:visited { text-decoration: none;}

		.myInput {
			width: 500px;
			padding: 5px;
			letter-spacing: 0.1em;
		}
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
		Statement stm =
				conn.createStatement();
		String sql = "select * from movie where movie_id = " + request.getParameter("mid");
		ResultSet rs = stm.executeQuery(sql);
		rs.next();
	%>
	<div class="header" style="margin: 20px auto; font-size: 32px;">
		<%=rs.getString("movie_name")%> (<%=rs.getString("year")%>)
	</div>

	<div style="margin: 30px auto; width: 1000px;">
		<table width="100%">
			<tr>
				<td width="20%">
					<div style="margin: 0 auto; text-align: left;">
						<img src="<%=rs.getString("img")%>" width="192px" height="256px">
					</div>
				</td>
				<td width="50%" style="padding: 0 50px 20px 10px; vertical-align: top;">
					<table class="movie_properties" cellpadding="5px">
						<tr>
							<th>Director: </th>
							<td>
								<%
									Statement stm_dir = conn.createStatement();
									String sql_dir = "select director_id, director_name\n" +
											"from movie_director join director using (director_id)\n" +
											"where movie_id = " + request.getParameter("mid");
									ResultSet rs_dir = stm_dir.executeQuery(sql_dir);
									rs_dir.next();
								%>
								<a href="director_profile.jsp?did=<%=rs_dir.getString("director_id")%>"><%=rs_dir.getString("director_name")%></a>
							</td>
						</tr>
						<tr>
							<th>Main actors: </th>
							<td>
								<%
									Statement stm_actor = conn.createStatement();
									String sql_actor = "select actor_id, actor_name\n" +
											"from movie_actor join actor using (actor_id)\n" +
											"where movie_id = " + request.getParameter("mid") + "\n" +
											"order by actor_num";
									ResultSet rs_actor = stm_actor.executeQuery(sql_actor);
									boolean printPattern = false;
									while(rs_actor.next())
									{
										if(rs_actor.getInt("actor_id") != 2 && rs_actor.getInt("actor_id") != 3 && rs_actor.getInt("actor_id") != 4)
										{
											if(printPattern)
												out.print(" / ");
								%>
								<a href="actor_profile.jsp?aid=<%=rs_actor.getString("actor_id")%>"><%=rs_actor.getString("actor_name")%></a>
								<%
											printPattern = true;
										}
									}
								%>
							</td>
						</tr>
						<tr>
							<th>Genre: </th>
							<td>
								<%
									Statement stm_genre = conn.createStatement();
									String sql_genre = "select genre_name\n" +
											"from movie_genre join genre using (genre_id)\n" +
											"where movie_id = " + request.getParameter("mid") + "\n" +
											"order by genre_name";
									ResultSet rs_genre = stm_genre.executeQuery(sql_genre);
									while(rs_genre.next())
									{
								%>
								<%=rs_genre.getString("genre_name")%>&nbsp;
								<%
									}
								%>
							</td>
						</tr>
						<tr>
							<th>Country: </th>
							<td><%=rs.getString("country")%></td>
						</tr>
						<tr>
							<th>Language: </th>
							<td>
								<%
									if (rs.getInt("language") == 1)
										out.print("Chinese");
									else if (rs.getInt("language") == 2)
										out.print("English");
									else if (rs.getInt("language") == 3)
										out.print("Japanese");
									else
										out.print("Others");
								%>
							</td>
						</tr>
						<tr>
							<th>Runtime: </th>
							<td><%=rs.getString("runtime")%> min</td>
						</tr>
						<tr>
							<th>Release Date: </th>
							<td><%=rs.getString("release_date")%></td>
						</tr>
					</table>
				</td>
				<td width="30%" style="color: #666666; font-weight: bold; padding: 0 50px 5px 15px; vertical-align: top; border-left: 1.5px solid #EAEAEA;">
					<%
						Statement stm_rating = conn.createStatement();
						String sql_rating = "select star, count(*) as num\n" +
								"from movie_user\n" +
								"where movie_id = " + request.getParameter("mid") + "\n" +
								"group by star\n" +
								"order by star desc";
						ResultSet rs_rating = stm_rating.executeQuery(sql_rating);
						int total = 0;
						int average = 0;
						int[] numPerStar = {0,0,0,0,0};
						while(rs_rating.next())
						{
							total += rs_rating.getInt("num");
							numPerStar[rs_rating.getInt("star") - 1] = rs_rating.getInt("num");
							average += rs_rating.getInt("star") * rs_rating.getInt("num");
						}
						float avg = (((float)average)/total)*2;
						int max = numPerStar[0];
						for(int i = 1; i < numPerStar.length; i++)
						{
							if(numPerStar[i] > max)
								max = numPerStar[i];
						}
						float[] percentagePerStar = {0,0,0,0,0};
						for(int i = 0; i < numPerStar.length; i++)
						{
							percentagePerStar[i] = ((float)numPerStar[i])/max*100;
						}
					%>
					<div style="padding-left: 3px; font-size: 1.2em;">Rating Analysis</div>
					<table cellpadding="3px;">
						<tr>
							<td id="big_score" style="color: black; font-size: 2.0em; font-weight: bold; padding: 7.5px 10px 7.5px 0px;"><%=String.format("%.1f",avg)%></td>
							<td style="font-size: 1.4em; padding-left: 3px;">
								<div class="checked fa fa-star"></div>
								<div class="checked <%if(avg >= 4.0) {%> fa fa-star <%} else if(avg >= 3.0) {%> fa fa-star-half-o <%} else {%> fa fa-star-o <%}%>"></div>
								<div class="checked <%if(avg >= 6.0) {%> fa fa-star <%} else if(avg >= 5.0) {%> fa fa-star-half-o <%} else {%> fa fa-star-o <%}%>"></div>
								<div class="checked <%if(avg >= 8.0) {%> fa fa-star <%} else if(avg >= 7.0) {%> fa fa-star-half-o <%} else {%> fa fa-star-o <%}%>"></div>
								<div class="checked <%if(avg >= 9.7) {%> fa fa-star <%} else if(avg >= 9.0) {%> fa fa-star-half-o <%} else {%> fa fa-star-o <%}%>"></div>
							</td>
						</tr>
					</table>
					<div style="padding-left: 3px; padding-bottom: 10px; border-bottom: 2px dotted #EAEAEA;">Based on <%=total%> reviews</div>
					<table style="text-align: center;" cellpadding="2px;">
						<tr>
							<td>Rating</td>
							<td></td>
							<td>Votes</td>
						</tr>
						<tr>
							<td>5</td>
							<td class="bar-container">
								<div class="bar-5" style="width: <%=percentagePerStar[4]%>%"></div>
							</td>
							<td><%=numPerStar[4]%></td>
						</tr>
						<tr>
							<td>4</td>
							<td class="bar-container">
								<div class="bar-4" style="width: <%=percentagePerStar[3]%>%"></div>
							</td>
							<td><%=numPerStar[3]%></td>
						</tr>
						<tr>
							<td>3</td>
							<td class="bar-container">
								<div class="bar-3" style="width: <%=percentagePerStar[2]%>%"></div>
							</td>
							<td><%=numPerStar[2]%></td>
						</tr>
						<tr>
							<td>2</td>
							<td class="bar-container">
								<div class="bar-2" style="width: <%=percentagePerStar[1]%>%"></div>
							</td>
							<td><%=numPerStar[1]%></td>
						</tr>
						<tr>
							<td>1</td>
							<td class="bar-container">
								<div class="bar-1" style="width: <%=percentagePerStar[0]%>%"></div>
							</td>
							<td><%=numPerStar[0]%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>

	<div class="header" style="margin: 20px auto; font-size: 24px; font-weight: bold; color: #007722;">
		<%=rs.getString("movie_name")%> 的剧情简介 ......
	</div>
	<div style="margin: 20px auto; font-size: 16px; font-weight: 500; letter-spacing: 1.5px; width: 1000px;">
		<%=rs.getString("storyline")%>
	</div>

	<%
		Statement stm_user = conn.createStatement();
		String sql_user = "select movie_user.*, users.username\n" +
				"from movie_user join users using(user_id)\n" +
				"where movie_id = " + request.getParameter("mid") + " and user_id = " + session.getAttribute("uid");
		ResultSet rs_user = stm_user.executeQuery(sql_user);
		if(!rs_user.next())
		{
	%>
	<div style="margin: 40px auto; width:800px;">
		<form method="post" action="AddCommentServlet">
			<input type="hidden" name="mid" value="<%=request.getParameter("mid")%>" />
			<table width="100%" style="text-align: left;">
				<tr>
					<td> <b>Rate the movie!</b> </td>
					<td class="rate" width="500px">
					    <input type="radio" id="star5" name="rate" value="5" required />
					    <label for="star5" title="text">5 stars</label>
					    <input type="radio" id="star4" name="rate" value="4" />
					    <label for="star4" title="text">4 stars</label>
					    <input type="radio" id="star3" name="rate" value="3" />
					    <label for="star3" title="text">3 stars</label>
					    <input type="radio" id="star2" name="rate" value="2" />
					    <label for="star2" title="text">2 stars</label>
					    <input type="radio" id="star1" name="rate" value="1" />
					    <label for="star1" title="text">1 star</label>
					</td>
				</tr>
				<tr>
					<td style="vertical-align:top"> <b>Title</b> </td>
					<td> <input type="text" class="myInput" name="title" style="width:500px" required/> </td>
				</tr>
				<tr>
					<td style="vertical-align:top"> <b>Content</b> </td>
					<td>
						<textarea class="myInput" name="content" style="width:500px; height:8em; white-space: pre-wrap; resize: none;" required></textarea>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align: right; padding-right: 157px;"> 
						<input type="submit"  style="margin-right: 10px;" />
						<input type="Reset" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<%
		}
		else
		{
			// co
	%>
	<div class="header" style="margin: 30px auto; font-size: 24px; font-weight: bold; color: #007722; text-align: center;">
		Editing Comment...
	</div>
	<div style="margin: 40px auto; width:800px;">
		<form method="post" action="EditCommentServlet">
			<input type="hidden" name="mid" value="<%=request.getParameter("mid")%>" />
			<table width="100%" style="text-align: left;">
				<tr>
					<td> <b>Rate the movie!</b> </td>
					<td class="rate" width="500px">
						<input type="radio" id="star5" name="rate" value="5" required/>
						<label for="star5" title="text">5 stars</label>
						<input type="radio" id="star4" name="rate" value="4" />
						<label for="star4" title="text">4 stars</label>
						<input type="radio" id="star3" name="rate" value="3" />
						<label for="star3" title="text">3 stars</label>
						<input type="radio" id="star2" name="rate" value="2" />
						<label for="star2" title="text">2 stars</label>
						<input type="radio" id="star1" name="rate" value="1" />
						<label for="star1" title="text">1 star</label>
					</td>
				</tr>
				<tr>
					<td style="vertical-align:top"> <b>Title</b> </td>
					<td> <input type="text" class="myInput" name="title" style="width:500px" value="<%=rs_user.getString("title")%>" required/> </td>
				</tr>
				<tr>
					<td style="vertical-align:top"> <b>Content</b> </td>
					<td>
						<textarea class="myInput" name="content" style="width:500px; height:8em; white-space: pre-wrap; resize: none;" required><%=rs_user.getString("content")%></textarea>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align: right; padding-right: 157px;">
						<input type="submit"  style="margin-right: 10px;" />
						<input type="Reset" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<%
		}
	%>

	<div class="header" style="margin: 20px auto; font-size: 24px; font-weight: bold; color: #007722;">
		<%=rs.getString("movie_name")%> 的评论... (全部<%=total%>条)
	</div>

	<%
		Statement stm_comment = conn.createStatement();
		String sql_comment = "select date_format(movie_user.last_modified, \"%Y-%m-%d %T\") as lm, movie_user.*, users.username\n" +
				"from movie_user join users using(user_id)\n" +
				"where movie_id = " + request.getParameter("mid") + "\n" +
				"order by last_modified desc";
		ResultSet rs_comment = stm_comment.executeQuery(sql_comment);
		while(rs_comment.next())
		{
	%>
	<div style="margin: 30px auto; width: 1000px;">
		<table width="100%">
			<tr style="float: left;">
				<td>
					<div style="margin: 0 auto; text-align: left; padding-right: 10px;">
						<a href="user_profile.jsp?uid=<%=rs_comment.getInt("user_id")%>">
							<img src="<%=rs_comment.getInt("user_id")%>.png" onerror="defaultImg(this)" width="36px" height="36px">
							<script>
								function defaultImg(img){
									img.src = "avatar.png";
									return true;
								}
							</script>
						</a>
					</div>
				</td>
				<td style="padding-right: 5px;">
					<a href="user_profile.jsp?uid=<%=rs_comment.getInt("user_id")%>"><%=rs_comment.getString("username")%></a>
				</td>
				<td style="padding-right: 10px; color: gray;">
					<div class="fa fa-star <%if(rs_comment.getInt("star") >= 1) {%> checked <%}%>"></div>
					<div class="fa fa-star <%if(rs_comment.getInt("star") >= 2) {%> checked <%}%>"></div>
					<div class="fa fa-star <%if(rs_comment.getInt("star") >= 3) {%> checked <%}%>"></div>
					<div class="fa fa-star <%if(rs_comment.getInt("star") >= 4) {%> checked <%}%>"></div>
					<div class="fa fa-star <%if(rs_comment.getInt("star") == 5) {%> checked <%}%>"></div>
				</td>
				<td> <%=rs_comment.getString("lm")%></td>
			</tr>
			<tr>
				<td style="padding: 10px 0; font-size: 1.2em;"><%=rs_comment.getString("title")%></td>
			</tr>
			<tr>
				<td style="padding: 5px 0;"><%=rs_comment.getString("content")%></td>
			</tr>
		</table>
	</div>
	<%
		}
	%>

	<div style="bottom:0px; width:100%; line-height:25px; margin-top:20px; text-align:center; padding:15px;">
		Copyright 2017 - 2020, Xiamen University <br/>
		Bookman Development Team
	</div>

	<button id="topBtn"><a href="#"><i class="fa fa-chevron-circle-up" style="color: black;"></a></i></button>

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