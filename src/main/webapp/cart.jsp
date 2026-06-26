<%@ page import="java.util.*,com.campus.takeaway.model.*,java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getAttribute("cart");
    BigDecimal total = (BigDecimal) request.getAttribute("total");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">校园外卖点餐系统</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/">首页</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>
<div class="container">
    <div class="panel">
        <h2>我的购物车</h2>
        <table>
            <tr>
                <th>菜品</th>
                <th>商家</th>
                <th>单价</th>
                <th>数量</th>
                <th>小计</th>
                <th>操作</th>
            </tr>
            <% for (CartItem item : cart.values()) { %>
            <tr>
                <td><%=item.getDish().getName()%></td>
                <td><%=item.getDish().getMerchantName()%></td>
                <td>￥<%=item.getDish().getPrice()%></td>
                <td>
                    <form class="form-inline" action="<%=request.getContextPath()%>/cart" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="dishId" value="<%=item.getDish().getId()%>">
                        <input type="number" name="quantity" min="0" value="<%=item.getQuantity()%>">
                        <button class="btn secondary" type="submit">修改</button>
                    </form>
                </td>
                <td>￥<%=item.getSubtotal()%></td>
                <td>
                    <form action="<%=request.getContextPath()%>/cart" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="dishId" value="<%=item.getDish().getId()%>">
                        <button class="btn danger" type="submit">删除</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <h3>合计：￥<%=total%></h3>
        <p>
            <a class="btn secondary" href="<%=request.getContextPath()%>/">继续点餐</a>
            <% if (!cart.isEmpty()) { %>
            <a class="btn" href="<%=request.getContextPath()%>/checkout">去结算</a>
            <% } %>
        </p>
    </div>
</div>
</body>
</html>
