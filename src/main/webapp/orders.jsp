<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">校园外卖点餐系统</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>
<div class="container">
    <div class="panel">
        <h2>我的订单</h2>
        <table>
            <tr>
                <th>订单号</th>
                <th>金额</th>
                <th>状态</th>
                <th>地址</th>
                <th>备注</th>
                <th>下单时间</th>
            </tr>
            <% for (Order order : orders) { %>
            <tr>
                <td><%=order.getOrderNo()%></td>
                <td>￥<%=order.getTotalAmount()%></td>
                <td><%=order.getStatus()%></td>
                <td><%=order.getAddressDetail()%></td>
                <td><%=order.getRemark() == null ? "" : order.getRemark()%></td>
                <td><%=order.getCreatedAt()%></td>
            </tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>
