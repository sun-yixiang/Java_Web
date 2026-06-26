<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生注册</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="login-box panel">
    <h2>学生注册</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%=request.getAttribute("error")%></div>
    <% } %>
    <form action="<%=request.getContextPath()%>/register" method="post">
        <label>用户名</label>
        <input name="username" required>
        <label>密码</label>
        <input name="password" type="password" required>
        <label>姓名</label>
        <input name="realName" required>
        <label>手机号</label>
        <input name="phone">
        <p><button class="btn" type="submit">注册</button></p>
    </form>
    <p><a href="<%=request.getContextPath()%>/login.jsp">已有账号？去登录</a></p>
</div>
</body>
</html>
