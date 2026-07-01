<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Merchant merchant = (Merchant) request.getAttribute("merchant");
    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
    User user = (User) session.getAttribute("user");
    if (merchant == null || dishes == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
    boolean isOpen = "open".equals(merchant.getStatus());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=merchant.getName()%></title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260701-img">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">
        校园外卖点餐系统
        <small>商家菜单</small>
    </div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a class="active" href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <% if (user == null) { %>
        <a href="<%=request.getContextPath()%>/login.jsp">登录</a>
        <a href="<%=request.getContextPath()%>/register.jsp">注册</a>
        <% } else { %>
        <span class="user-name"><%=user.getRealName()%></span>
        <% if ("admin".equals(user.getRole())) { %>
        <a href="<%=request.getContextPath()%>/admin/dashboard">后台</a>
        <% } else if ("merchant".equals(user.getRole())) { %>
        <a href="<%=request.getContextPath()%>/merchant-admin/dashboard">商家后台</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
        <% } %>
    </div>
</div>

<main class="user-container">
    <section class="merchant-hero user-panel">
        <div>
            <a class="back-link" href="<%=request.getContextPath()%>/home">返回首页</a>
            <h1><%=merchant.getName()%></h1>
            <p><%=merchant.getDescription()%></p>
            <div class="merchant-meta">
                <span><%=merchant.getAddress()%></span>
                <span><%=merchant.getPhone()%></span>
                <span>评分 <%=merchant.getScore() == null ? "0.0" : merchant.getScore()%></span>
                <span class="<%=isOpen ? "status-open" : "status-closed"%>"><%=isOpen ? "营业中" : "休息中"%></span>
            </div>
        </div>
        <div class="merchant-summary">
            <strong><%=dishes.size()%></strong>
            <span>本店可点菜品</span>
        </div>
    </section>

    <section class="section">
        <div class="user-section-title">
            <h2>本店菜单</h2>
            <span>点击菜品即可加入购物车</span>
        </div>
        <% if (!isOpen) { %>
        <div class="user-alert warning">商家当前已关闭，暂时不能点餐。</div>
        <% } else if (dishes.isEmpty()) { %>
        <div class="user-alert warning">本店暂无可售菜品，请看看其他商家。</div>
        <% } %>
        <div class="user-grid dish-grid">
            <% for (Dish dish : dishes) { %>
            <%
                String imageUrl = dish.getImageUrl();
                String imageSrc;
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageSrc = request.getContextPath() + "/assets/images/dishes/staple.jpg";
                } else if (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")) {
                    imageSrc = imageUrl;
                } else if (imageUrl.startsWith("/")) {
                    imageSrc = request.getContextPath() + imageUrl;
                } else {
                    imageSrc = request.getContextPath() + "/" + imageUrl;
                }
            %>
            <div class="user-card dish-card <%=dish.getStock() <= 0 ? "is-sold-out" : ""%>">
                <div class="dish-image-wrap">
                    <img src="<%=imageSrc%>" alt="<%=dish.getName()%>">
                </div>
                <p class="muted"><%=dish.getCategoryName()%></p>
                <h3><%=dish.getName()%></h3>
                <p><%=dish.getDescription()%></p>
                <div class="user-price">￥<%=dish.getPrice()%></div>
                <p class="muted">评分：<%=dish.getScore() == null ? "0.0" : dish.getScore()%> · 库存：<%=dish.getStock()%></p>
                <form action="<%=request.getContextPath()%>/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="dishId" value="<%=dish.getId()%>">
                    <button class="btn" type="submit" <%=dish.getStock() > 0 ? "" : "disabled"%>>
                        <%=dish.getStock() > 0 ? "加入购物车" : "已售罄"%>
                    </button>
                </form>
            </div>
            <% } %>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
