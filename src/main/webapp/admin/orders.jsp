<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">外卖后台管理</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
    </div>
</div>
<div class="container">
    <div class="panel">
        <h2>订单列表</h2>
        <table>
            <tr><th>订单号</th><th>用户</th><th>金额</th><th>地址</th><th>状态</th><th>备注</th><th>操作</th></tr>
            <% for (Order order : orders) { %>
            <tr>
                <td><%=order.getOrderNo()%></td>
                <td><%=order.getUserName()%></td>
                <td>￥<%=order.getTotalAmount()%></td>
                <td><%=order.getAddressDetail()%></td>
                <td><%=order.getStatus()%></td>
                <td><%=order.getRemark() == null ? "" : order.getRemark()%></td>
                <td>
                    <form class="form-inline" action="<%=request.getContextPath()%>/admin/orders" method="post">
                        <input type="hidden" name="id" value="<%=order.getId()%>">
                        <select name="status">
                            <option value="created">created</option>
                            <option value="paid">paid</option>
                            <option value="delivering">delivering</option>
                            <option value="finished">finished</option>
                            <option value="cancelled">cancelled</option>
                        </select>
                        <button class="btn" type="submit">更新</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>
