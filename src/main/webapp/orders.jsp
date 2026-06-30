<%@ page import="java.util.*,com.campus.takeaway.model.*,com.campus.takeaway.util.StatusText" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260626">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">校园外卖点餐系统<small>我的订单</small></div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a class="active" href="<%=request.getContextPath()%>/orders">我的订单</a>
        <span class="user-name"><%=user == null ? "" : user.getRealName()%></span>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="user-container">
    <section class="user-panel">
        <div class="user-section-title">
            <h2>我的订单</h2>
            <span>共 <%=orders.size()%> 笔订单</span>
        </div>
        <div class="user-table-wrap">
            <table>
                <tr><th>订单号</th><th>金额</th><th>状态</th><th>地址</th><th>备注</th><th>下单时间</th></tr>
                <% for (Order order : orders) { %>
                <tr>
                    <td><%=order.getOrderNo()%></td>
                    <td>￥<%=order.getTotalAmount()%></td>
                    <td><%=StatusText.order(order.getStatus())%></td>
                    <td><%=order.getAddressDetail()%></td>
                    <td><%=order.getRemark() == null ? "" : order.getRemark()%></td>
                    <td><%=order.getCreatedAt()%></td>
                </tr>
                <% } %>
            </table>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
