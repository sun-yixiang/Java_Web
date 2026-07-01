<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260701-img">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">校园外卖点餐系统<small>账号登录</small></div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <a class="active" href="<%=request.getContextPath()%>/login.jsp">登录</a>
        <a href="<%=request.getContextPath()%>/register.jsp">注册</a>
    </div>
</div>

<main class="auth-shell">
    <section class="auth-card">
        <h2>欢迎回来</h2>
        <p>登录后可以继续点餐、查看购物车和订单状态。</p>
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
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
