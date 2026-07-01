<%@ page import="java.util.*,java.text.SimpleDateFormat,com.campus.takeaway.model.*,com.campus.takeaway.util.StatusText" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Merchant merchant = (Merchant) request.getAttribute("merchant");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Map<Integer, List<OrderItem>> orderItems = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItems");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商家订单管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page merchant-admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        商家运营后台
        <small><%=merchant == null ? "订单处理" : merchant.getName()%></small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="merchant-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/merchant-admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/merchant-admin/dishes">菜品管理</a>
        <a class="active" href="<%=request.getContextPath()%>/merchant-admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>本店订单</h2>
            <span>共 <%=orders.size()%> 笔</span>
        </div>
        <div class="admin-table-wrap">
            <table>
                <tr><th>订单号</th><th>用户</th><th>本店金额</th><th>本店菜品</th><th>地址</th><th>状态</th><th>下单时间</th><th>操作</th></tr>
                <% for (Order order : orders) { %>
                <tr>
                    <td><%=order.getOrderNo()%></td>
                    <td><%=order.getUserName()%></td>
                    <td>￥<%=order.getTotalAmount()%></td>
                    <td>
                        <% for (OrderItem item : orderItems.get(order.getId())) { %>
                        <div class="admin-order-item"><%=item.getDishName()%> × <%=item.getQuantity()%></div>
                        <% } %>
                    </td>
                    <td><%=order.getAddressDetail()%></td>
                    <td><span class="admin-badge admin-status-<%=order.getStatus()%>"><%=StatusText.order(order.getStatus())%></span></td>
                    <td><%=order.getCreatedAt() == null ? "" : dateFormat.format(order.getCreatedAt())%></td>
                    <td>
                        <form class="form-inline" action="<%=request.getContextPath()%>/merchant-admin/orders" method="post">
                            <input type="hidden" name="id" value="<%=order.getId()%>">
                            <select name="status">
                                <option value="created" <%= "created".equals(order.getStatus()) ? "selected" : ""%>>待处理</option>
                                <option value="paid" <%= "paid".equals(order.getStatus()) ? "selected" : ""%>>已支付</option>
                                <option value="delivering" <%= "delivering".equals(order.getStatus()) ? "selected" : ""%>>配送中</option>
                                <option value="finished" <%= "finished".equals(order.getStatus()) ? "selected" : ""%>>已完成</option>
                                <option value="cancelled" <%= "cancelled".equals(order.getStatus()) ? "selected" : ""%>>已取消</option>
                            </select>
                            <button class="btn" type="submit">更新</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
