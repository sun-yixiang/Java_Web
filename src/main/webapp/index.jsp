<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260625">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home-glass.css?v=20260625">
</head>
<body class="home-glass">
<div class="topbar">
    <div class="brand">
        校园外卖点餐系统
        <small>Campus Takeaway Service</small>
    </div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <% if (user == null) { %>
        <a href="<%=request.getContextPath()%>/login.jsp">登录</a>
        <a href="<%=request.getContextPath()%>/register.jsp">注册</a>
        <% } else { %>
        <span>你好，<%=user.getRealName()%></span>
        <% if ("admin".equals(user.getRole())) { %>
        <a href="<%=request.getContextPath()%>/admin/dashboard">后台</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
        <% } %>
    </div>
</div>

<main class="container">
    <section class="hero">
        <div class="hero-grid">
            <div class="hero-copy">
                <div>
                    <div class="eyebrow">校内餐饮 · 即时点单 · 宿舍配送</div>
                    <h1>让校园点餐更轻、更快、更有秩序</h1>
                    <p>
                        聚合校内商家、菜品、地址和订单管理，学生可以快速浏览菜品并下单，
                        管理员可以维护商家、菜品和订单状态。这个版本采用毛玻璃视觉，
                        更适合实训演示和答辩展示。
                    </p>
                    <div class="hero-actions">
                        <a class="btn" href="#menu">开始点餐</a>
                        <a class="btn secondary" href="<%=request.getContextPath()%>/cart">查看购物车</a>
                        <% if (user == null) { %>
                        <a class="btn secondary" href="<%=request.getContextPath()%>/login.jsp">登录账号</a>
                        <% } %>
                    </div>
                </div>
                <div class="hero-metrics">
                    <div class="metric">
                        <strong><%=merchants.size()%></strong>
                        <span>入驻商家</span>
                    </div>
                    <div class="metric">
                        <strong><%=dishes.size()%></strong>
                        <span>可选菜品</span>
                    </div>
                    <div class="metric">
                        <strong><%=announcements.size()%></strong>
                        <span>平台公告</span>
                    </div>
                </div>
            </div>

            <aside class="hero-side">
                <div class="panel">
                    <div class="section-title">
                        <h2>今晚吃点什么</h2>
                        <span>按菜品、商家或分类搜索</span>
                    </div>
                    <form class="search-bar" action="<%=request.getContextPath()%>/home" method="get">
                        <input type="text" name="keyword" placeholder="例如：奶茶、炒饭、一食堂">
                        <button class="btn" type="submit">搜索</button>
                    </form>
                </div>

                <div class="panel">
                    <div class="section-title">
                        <h2>系统公告</h2>
                        <span>最新通知</span>
                    </div>
                    <% for (Announcement item : announcements) { %>
                    <p><strong><%=item.getTitle()%></strong></p>
                    <p class="muted"><%=item.getContent()%></p>
                    <% } %>
                </div>

                <div class="panel">
                    <div class="section-title">
                        <h2>点餐流程</h2>
                        <span>四步完成</span>
                    </div>
                    <p class="muted">浏览菜品 → 加入购物车 → 选择地址 → 提交订单</p>
                </div>
            </aside>
        </div>
    </section>

    <section class="section">
        <div class="section-title">
            <h2>校园商家</h2>
            <span>校内窗口与特色小店</span>
        </div>
        <div class="grid">
            <% for (Merchant merchant : merchants) { %>
            <div class="card">
                <h3><%=merchant.getName()%></h3>
                <p class="muted"><%=merchant.getDescription()%></p>
                <p><%=merchant.getAddress()%></p>
                <p class="muted">电话：<%=merchant.getPhone()%> · 状态：<%=merchant.getStatus()%></p>
            </div>
            <% } %>
        </div>
    </section>

    <section id="menu" class="section">
        <div class="section-title">
            <h2>推荐菜品</h2>
            <span>从这里开始今天的晚餐</span>
        </div>
        <div class="grid">
            <% for (Dish dish : dishes) { %>
            <div class="card">
                <p class="muted"><%=dish.getMerchantName()%> · <%=dish.getCategoryName()%></p>
                <h3><%=dish.getName()%></h3>
                <p><%=dish.getDescription()%></p>
                <div class="price">￥<%=dish.getPrice()%></div>
                <p class="muted">库存：<%=dish.getStock()%> · 状态：<%=dish.getStatus()%></p>
                <form action="<%=request.getContextPath()%>/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="dishId" value="<%=dish.getId()%>">
                    <button class="btn" type="submit">加入购物车</button>
                </form>
            </div>
            <% } %>
        </div>
    </section>
</main>
</body>
</html>
