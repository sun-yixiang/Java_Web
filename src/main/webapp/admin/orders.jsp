<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        外卖后台管理
        <small>Order Dispatch</small>
    </div>
    <div class="admin-nav">
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
        <a class="active" href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>订单列表</h2>
            <span>共 <%=orders.size()%> 笔订单</span>
        </div>
        <div class="admin-table-wrap">
            <table>
                <tr><th>订单号</th><th>用户</th><th>金额</th><th>地址</th><th>状态</th><th>备注</th><th>操作</th></tr>
                <% for (Order order : orders) { %>
                <tr>
                    <td><%=order.getOrderNo()%></td>
                    <td><%=order.getUserName()%></td>
                    <td>￥<%=order.getTotalAmount()%></td>
                    <td><%=order.getAddressDetail()%></td>
                    <td><span class="admin-badge admin-status-<%=order.getStatus()%>"><%=order.getStatus()%></span></td>
                    <td><%=order.getRemark() == null ? "" : order.getRemark()%></td>
                    <td>
                        <form class="form-inline" action="<%=request.getContextPath()%>/admin/orders" method="post">
                            <input type="hidden" name="id" value="<%=order.getId()%>">
                            <select name="status">
                                <option value="created" <%= "created".equals(order.getStatus()) ? "selected" : ""%>>created</option>
                                <option value="paid" <%= "paid".equals(order.getStatus()) ? "selected" : ""%>>paid</option>
                                <option value="delivering" <%= "delivering".equals(order.getStatus()) ? "selected" : ""%>>delivering</option>
                                <option value="finished" <%= "finished".equals(order.getStatus()) ? "selected" : ""%>>finished</option>
                                <option value="cancelled" <%= "cancelled".equals(order.getStatus()) ? "selected" : ""%>>cancelled</option>
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
</body>
</html>
