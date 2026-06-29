<%@ page import="java.util.*,com.campus.takeaway.model.*,java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getAttribute("cart");
    BigDecimal total = (BigDecimal) request.getAttribute("total");
    User user = (User) session.getAttribute("user");
    String cartMessage = (String) request.getAttribute("cartMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260626">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">校园外卖点餐系统<small>Shopping Cart</small></div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a class="active" href="<%=request.getContextPath()%>/cart">购物车</a>
        <a href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <span class="user-name"><%=user == null ? "" : user.getRealName()%></span>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="user-container">
    <section class="user-panel">
        <div class="user-section-title">
            <h2>我的购物车</h2>
            <span>确认菜品数量和金额</span>
        </div>
        <% if (cartMessage != null) { %>
        <div class="user-alert warning"><%=cartMessage%></div>
        <% } %>
        <div class="user-table-wrap">
            <table>
                <tr><th>菜品</th><th>商家</th><th>单价</th><th>数量</th><th>小计</th><th>操作</th></tr>
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
        </div>
        <div class="user-total">
            <span>合计金额 <strong>￥<%=total%></strong></span>
            <span>
                <a class="btn secondary" href="<%=request.getContextPath()%>/home">继续点餐</a>
                <% if (!cart.isEmpty()) { %>
                <a class="btn" href="<%=request.getContextPath()%>/checkout">去结算</a>
                <% } %>
            </span>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
