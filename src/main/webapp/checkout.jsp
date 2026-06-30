<%@ page import="java.util.*,com.campus.takeaway.model.*,java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getAttribute("cart");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    BigDecimal total = (BigDecimal) request.getAttribute("total");
    User user = (User) session.getAttribute("user");
    boolean hasAddresses = addresses != null && !addresses.isEmpty();
    String checkoutError = (String) request.getAttribute("checkoutError");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>提交订单</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/user.css?v=20260626">
</head>
<body class="user-page">
<div class="user-topbar">
    <div class="user-brand">校园外卖点餐系统<small>提交订单</small></div>
    <div class="user-nav" data-nav-slider data-nav-key="student-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/home">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
        <a class="active" href="<%=request.getContextPath()%>/checkout">去结算</a>
        <a href="<%=request.getContextPath()%>/orders">我的订单</a>
        <span class="user-name"><%=user == null ? "" : user.getRealName()%></span>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="user-container">
    <section class="user-panel">
        <div class="user-section-title">
            <h2>确认订单</h2>
            <span>检查菜品明细和配送地址</span>
        </div>
        <div class="user-table-wrap">
            <table>
                <tr><th>菜品</th><th>数量</th><th>小计</th></tr>
                <% for (CartItem item : cart.values()) { %>
                <tr>
                    <td><%=item.getDish().getName()%></td>
                    <td><%=item.getQuantity()%></td>
                    <td>￥<%=item.getSubtotal()%></td>
                </tr>
                <% } %>
            </table>
        </div>
        <div class="user-total">
            <span>应付金额 <strong>￥<%=total%></strong></span>
            <a class="btn secondary" href="<%=request.getContextPath()%>/cart">返回购物车</a>
        </div>
    </section>

    <section class="user-panel">
        <div class="user-section-title">
            <h2>选择收货地址</h2>
            <span>确认宿舍楼与联系电话</span>
        </div>
        <form action="<%=request.getContextPath()%>/checkout" method="post">
            <% if (checkoutError != null) { %>
            <div class="user-alert error"><%=checkoutError%></div>
            <% } %>
            <% if (!hasAddresses) { %>
            <div class="user-alert warning">还没有收货地址。请先在下方新增地址，保存后再提交订单。</div>
            <% } %>
            <% if (hasAddresses) { %>
            <% for (Address address : addresses) { %>
            <p>
                <label>
                    <input style="width:auto" type="radio" name="addressId" value="<%=address.getId()%>" required <%=address.isDefaultAddress() ? "checked" : ""%>>
                    <%=address.getReceiverName()%> <%=address.getPhone()%> <%=address.getDetail()%>
                </label>
            </p>
            <% } %>
            <% } %>
            <label>订单备注</label>
            <textarea name="remark" rows="3" placeholder="例如：少辣、送到宿舍楼下"></textarea>
            <p>
                <button class="btn" type="submit" <%=hasAddresses ? "" : "disabled"%>>
                    <%=hasAddresses ? "提交订单" : "请先新增地址"%>
                </button>
            </p>
        </form>
    </section>

    <section class="user-panel">
        <div class="user-section-title">
            <h2>新增地址</h2>
            <span>第一次下单可在这里补充</span>
        </div>
        <form action="<%=request.getContextPath()%>/address" method="post">
            <div class="user-form-grid">
                <div>
                    <label>收货人</label>
                    <input name="receiverName" required>
                </div>
                <div>
                    <label>电话</label>
                    <input name="phone" required>
                </div>
                <div class="full">
                    <label>详细地址</label>
                    <input name="detail" placeholder="例如：3号宿舍楼 502" required>
                </div>
            </div>
            <p><button class="btn secondary" type="submit">保存地址</button></p>
        </form>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
