<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="login-box panel">
    <h2>用户登录</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%=request.getAttribute("error")%></div>
    <% } %>
    <form action="<%=request.getContextPath()%>/login" method="post">
        <label>用户名</label>
        <input name="username" required>
        <label>密码</label>
        <input name="password" type="password" required>
        <p><button class="btn" type="submit">登录</button></p>
    </form>
    <p class="muted">管理员：admin / admin123，学生：student / 123456</p>
    <p><a href="<%=request.getContextPath()%>/register.jsp">没有账号？去注册</a></p>
</div>
</body>
</html>
