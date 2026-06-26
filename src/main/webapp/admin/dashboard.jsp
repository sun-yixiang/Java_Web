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
        <small>Campus Takeaway Console</small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="admin-nav">
        <span class="nav-indicator"></span>
        <a class="active" href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
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
                当前页面已采用毛玻璃控制台风格，导航会在所有后台页面保持一致，并以浅色玻璃态标记当前模块。
            </p>
        </div>
        <div class="admin-quick-panel">
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/merchants">
                <span><strong>维护商家</strong>新增窗口、编辑联系电话与营业状态</span>
                <em>→</em>
            </a>
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/dishes">
                <span><strong>更新菜品</strong>调整价格、库存、分类与上下架</span>
                <em>→</em>
            </a>
            <a class="admin-action-card" href="<%=request.getContextPath()%>/admin/orders">
                <span><strong>处理订单</strong>查看订单并推进配送状态</span>
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
        <div class="admin-stat dish">
            <strong><%=request.getAttribute("dishCount")%></strong>
            <span>菜品数量</span>
            <small>支持主食、饮品、小吃等分类</small>
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
                <p class="muted">午餐和晚餐前确认菜品库存、价格和商家营业状态，避免学生下单后无法处理。</p>
            </div>
            <div class="card">
                <h3>订单状态流转</h3>
                <p class="muted">订单建议按 created、paid、delivering、finished 的顺序维护，异常订单及时取消。</p>
            </div>
            <div class="card">
                <h3>演示答辩路线</h3>
                <p class="muted">先展示首页点餐，再登录后台维护菜品，最后更新订单状态，流程最完整。</p>
            </div>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
