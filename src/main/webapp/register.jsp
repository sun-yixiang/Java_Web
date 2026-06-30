<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生注册</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260626">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">校园外卖点餐系统<small>创建账号</small></div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <a href="<%=request.getContextPath()%>/login.jsp">登录</a>
        <a class="active" href="<%=request.getContextPath()%>/register.jsp">注册</a>
    </div>
</div>

<main class="auth-shell">
    <section class="auth-card">
        <h2>创建学生账号</h2>
        <p>注册后即可浏览菜品、加入购物车并提交订单。</p>
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
            <input name="phone" type="tel" pattern="1[3-9][0-9]{9}" maxlength="11" placeholder="请输入 11 位手机号" required>
            <p><button class="btn" type="submit">注册</button></p>
        </form>
        <p><a href="<%=request.getContextPath()%>/login.jsp">已有账号？去登录</a></p>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
