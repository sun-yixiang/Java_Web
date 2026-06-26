<%@ page import="java.util.*,com.campus.takeaway.model.*,java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getAttribute("cart");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    BigDecimal total = (BigDecimal) request.getAttribute("total");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>提交订单</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">校园外卖点餐系统</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/">首页</a>
        <a href="<%=request.getContextPath()%>/cart">购物车</a>
    </div>
</div>
<div class="container">
    <div class="panel">
        <h2>确认订单</h2>
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
        <h3>应付金额：￥<%=total%></h3>
    </div>

    <div class="panel">
        <h2>选择收货地址</h2>
        <form action="<%=request.getContextPath()%>/checkout" method="post">
            <% for (Address address : addresses) { %>
            <p>
                <label>
                    <input style="width:auto" type="radio" name="addressId" value="<%=address.getId()%>" required <%=address.isDefaultAddress() ? "checked" : ""%>>
                    <%=address.getReceiverName()%> <%=address.getPhone()%> <%=address.getDetail()%>
                </label>
            </p>
            <% } %>
            <label>订单备注</label>
            <textarea name="remark" rows="3" placeholder="例如：少辣、送到宿舍楼下"></textarea>
            <p><button class="btn" type="submit">提交订单</button></p>
        </form>
    </div>

    <div class="panel">
        <h2>新增地址</h2>
        <form action="<%=request.getContextPath()%>/address" method="post">
            <label>收货人</label>
            <input name="receiverName" required>
            <label>电话</label>
            <input name="phone" required>
            <label>详细地址</label>
            <input name="detail" placeholder="例如：3号宿舍楼 502" required>
            <p><button class="btn secondary" type="submit">保存地址</button></p>
        </form>
    </div>
</div>
</body>
</html>
