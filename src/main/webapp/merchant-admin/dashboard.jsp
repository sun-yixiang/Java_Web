<%@ page import="com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Merchant merchant = (Merchant) request.getAttribute("merchant");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商家后台</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page merchant-admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        商家运营后台
        <small><%=merchant == null ? "商家工作台" : merchant.getName()%></small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="merchant-nav">
        <span class="nav-indicator"></span>
        <a class="active" href="<%=request.getContextPath()%>/merchant-admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/merchant-admin/dishes">菜品管理</a>
        <a href="<%=request.getContextPath()%>/merchant-admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-hero">
        <div class="admin-hero-card">
            <span class="admin-kicker">商家专属控制台</span>
            <h1><%=merchant == null ? "商家后台" : merchant.getName()%></h1>
            <p>
                当前账号只能维护本店菜品和本店订单，菜品评分会影响推荐顺序，
                商家评分由管理员在平台后台维护，评分越高，学生首页展示越靠前。
            </p>
        </div>
        <div class="admin-quick-panel">
            <a class="admin-action-card" href="<%=request.getContextPath()%>/merchant-admin/dishes">
                <span><strong>维护菜品</strong>新增菜品、调整价格、库存、状态和菜品评分</span>
                <em>→</em>
            </a>
            <a class="admin-action-card" href="<%=request.getContextPath()%>/merchant-admin/orders">
                <span><strong>处理订单</strong>仅查看购买本店菜品的订单并更新状态</span>
                <em>→</em>
            </a>
        </div>
    </section>

    <section class="admin-stats two">
        <div class="admin-stat dish">
            <strong><%=request.getAttribute("dishCount")%></strong>
            <span>本店菜品</span>
            <small>支持上下架、库存和评分维护</small>
        </div>
        <div class="admin-stat order">
            <strong><%=request.getAttribute("orderCount")%></strong>
            <span>本店订单</span>
            <small>只统计包含本店菜品的订单</small>
        </div>
    </section>

    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>店铺状态</h2>
            <span>营业信息</span>
        </div>
        <% if (merchant != null) { %>
        <div class="admin-info-grid">
            <div><strong>店铺名称</strong><span><%=merchant.getName()%></span></div>
            <div><strong>店铺评分</strong><span><%=merchant.getScore() == null ? "0.0" : merchant.getScore()%> 分</span></div>
            <div><strong>营业状态</strong><span><%="open".equals(merchant.getStatus()) ? "营业中" : "已关闭"%></span></div>
            <div><strong>联系电话</strong><span><%=merchant.getPhone()%></span></div>
        </div>
        <% } %>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
