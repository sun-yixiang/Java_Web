<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台首页</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        外卖后台管理
        <small>校园外卖运营控制台</small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="admin-nav">
        <span class="nav-indicator"></span>
        <a class="active" href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/users">用户管理</a>
        <a href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-hero">
        <div class="admin-hero-card">
            <span class="admin-kicker">实时运营看板</span>
            <h1>今天的校园餐饮，一眼掌握</h1>
            <p>
                后台聚合商家、菜品和订单数据，管理员可以从这里快速进入维护流程。
                管理员负责商家、用户和平台全部订单的管理；菜品维护和商家订单处理由商家后台负责。
            </p>
        </div>
        <div class="admin-quick-panel">
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/merchants">
                <span><strong>维护商家</strong>新增窗口、编辑联系电话、营业状态与评分</span>
                <em>→</em>
            </a>
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/users">
                <span><strong>管理用户</strong>维护学生、管理员和一对一商家账号</span>
                <em>→</em>
            </a>
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/orders">
                <span><strong>查看订单</strong>管理平台全部订单与整体状态</span>
                <em>→</em>
            </a>
        </div>
    </section>

    <section class="admin-stats">
        <div class="admin-stat merchant">
            <strong><%=request.getAttribute("merchantCount")%></strong>
            <span>商家数量</span>
            <small>覆盖校内窗口与特色店铺</small>
        </div>
        <div class="admin-stat user">
            <strong><%=request.getAttribute("userCount")%></strong>
            <span>用户数量</span>
            <small>包含学生、管理员与商家账号</small>
        </div>
        <div class="admin-stat order">
            <strong><%=request.getAttribute("orderCount")%></strong>
            <span>订单数量</span>
            <small>追踪创建、配送与完成状态</small>
        </div>
    </section>

    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>后台工作台</h2>
            <span>常用维护建议</span>
        </div>
        <div class="grid">
            <div class="card">
                <h3>高峰前检查</h3>
                <p class="muted">午餐和晚餐前确认商家营业状态和评分，菜品库存由对应商家账号维护。</p>
            </div>
            <div class="card">
                <h3>订单状态流转</h3>
                <p class="muted">平台可查看全部订单，具体商家订单由对应商家账号跟进处理。</p>
            </div>
            <div class="card">
                <h3>演示答辩路线</h3>
                <p class="muted">先展示首页点餐，再登录商家后台维护菜品，最后回到管理员后台查看平台订单。</p>
            </div>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
