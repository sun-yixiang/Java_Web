<%@ page import="java.util.*,com.campus.takeaway.model.*,com.campus.takeaway.util.StatusText" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
    List<Merchant> merchants = (List<Merchant>) request.getAttribute("merchants");
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    User user = (User) session.getAttribute("user");
    if (dishes == null || merchants == null || announcements == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园外卖点餐系统</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260626">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">
        校园外卖点餐系统
        <small>校园外卖点餐服务</small>
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
        <% } %>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
        <% } %>
    </div>
</div>

<main class="user-container">
    <section class="user-hero">
        <div class="user-hero-grid">
            <div class="user-hero-copy">
                <div>
                    <div class="user-eyebrow">校内餐饮 · 即时点单 · 宿舍配送</div>
                    <h1>让校园点餐更轻、更快、更有秩序</h1>
                    <p>
                        聚合校内商家、菜品、地址和订单管理，学生可以快速浏览菜品并下单，
                        管理员可以维护商家、菜品和订单状态。整体界面采用深色毛玻璃控制台风格，
                        导航切换拥有平滑滑动反馈。
                    </p>
                    <div class="user-hero-actions">
                        <a class="btn" href="#menu">开始点餐</a>
                        <a class="btn secondary" href="<%=request.getContextPath()%>/cart">查看购物车</a>
                        <% if (user == null) { %>
                        <a class="btn secondary" href="<%=request.getContextPath()%>/login.jsp">登录账号</a>
                        <% } %>
                    </div>
                </div>
                <div class="user-stats">
                    <div class="user-stat"><strong><%=merchants.size()%></strong><span>入驻商家</span></div>
                    <div class="user-stat"><strong><%=dishes.size()%></strong><span>可选菜品</span></div>
                    <div class="user-stat"><strong><%=announcements.size()%></strong><span>平台公告</span></div>
                </div>
            </div>

            <aside class="user-side">
                <div class="user-panel">
                    <div class="user-section-title">
                        <h2>今晚吃点什么</h2>
                        <span>按菜品、商家或分类搜索</span>
                    </div>
                    <form class="search-bar" action="<%=request.getContextPath()%>/home" method="get">
                        <input type="text" name="keyword" placeholder="例如：奶茶、炒饭、一食堂">
                        <button class="btn" type="submit">搜索</button>
                    </form>
                </div>
                <div class="user-panel">
                    <div class="user-section-title">
                        <h2>系统公告</h2>
                        <span>最新通知</span>
                    </div>
                    <% for (Announcement item : announcements) { %>
                    <p><strong><%=item.getTitle()%></strong></p>
                    <p class="muted"><%=item.getContent()%></p>
                    <% } %>
                </div>
                <div class="user-panel">
                    <div class="user-section-title">
                        <h2>点餐流程</h2>
                        <span>四步完成</span>
                    </div>
                    <p class="muted">浏览菜品 → 加入购物车 → 选择地址 → 提交订单</p>
                </div>
            </aside>
        </div>
    </section>

    <section class="section">
        <div class="user-section-title">
            <h2>校园商家</h2>
            <span>校内窗口与特色小店</span>
        </div>
        <div class="user-grid merchant-grid">
            <% for (Merchant merchant : merchants) { %>
            <a class="user-card merchant-card <%= "open".equals(merchant.getStatus()) ? "" : "is-closed" %>" href="<%=request.getContextPath()%>/merchant?id=<%=merchant.getId()%>">
                <h3><%=merchant.getName()%></h3>
                <p><%=merchant.getDescription()%></p>
                <p><%=merchant.getAddress()%></p>
                <p class="muted">电话：<%=merchant.getPhone()%> · 状态：<%=StatusText.merchant(merchant.getStatus())%></p>
                <span class="merchant-card-action"><%= "open".equals(merchant.getStatus()) ? "查看本店菜品" : "商家休息中" %></span>
            </a>
            <% } %>
        </div>
    </section>

    <section id="menu" class="section">
        <div class="user-section-title">
            <h2>推荐菜品</h2>
            <span>从这里开始今天的晚餐</span>
        </div>
        <div class="user-grid">
            <% for (Dish dish : dishes) { %>
            <div class="user-card dish-card <%=dish.getStock() <= 0 ? "is-sold-out" : ""%>">
                <p class="muted"><%=dish.getMerchantName()%> · <%=dish.getCategoryName()%></p>
                <h3><%=dish.getName()%></h3>
                <p><%=dish.getDescription()%></p>
                <div class="user-price">￥<%=dish.getPrice()%></div>
                <p class="muted">库存：<%=dish.getStock()%> · 状态：<%=StatusText.dish(dish.getStatus())%></p>
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
