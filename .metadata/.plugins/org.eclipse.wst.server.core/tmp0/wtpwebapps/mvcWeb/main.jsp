<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div align="center">Intro page . . . . . .  . . . . . . . .</div>
	<form method="post" action="./test.do">
		<input type="text" name="id" id="id"><br/>
		<input type="text" name="pwd" id="pwd"><br/>
		<input type="submit" value="전송"/><br/>
	</form>
	<hr/>
	<a href="./test.do?id=jssim&pwd=jssim">link~</a>
	<hr/>
	
	<a href="./ajax.do">just a link</a>
	
</body>
</html>