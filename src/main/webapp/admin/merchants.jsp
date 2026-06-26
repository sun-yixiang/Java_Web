<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Merchant> merchants = (List<Merchant>) request.getAttribute("merchants");
    Merchant merchant = (Merchant) request.getAttribute("merchant");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商家管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">外卖后台管理</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
        <a href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
    </div>
</div>
<div class="container">
    <div class="panel">
        <h2><%=merchant == null ? "新增商家" : "编辑商家"%></h2>
        <form action="<%=request.getContextPath()%>/admin/merchants" method="post">
            <input type="hidden" name="id" value="<%=merchant == null ? "" : merchant.getId()%>">
            <label>商家名称</label>
            <input name="name" value="<%=merchant == null ? "" : merchant.getName()%>" required>
            <label>简介</label>
            <input name="description" value="<%=merchant == null ? "" : merchant.getDescription()%>">
            <label>电话</label>
            <input name="phone" value="<%=merchant == null ? "" : merchant.getPhone()%>">
            <label>地址</label>
            <input name="address" value="<%=merchant == null ? "" : merchant.getAddress()%>">
            <label>状态</label>
            <select name="status">
                <option value="open">open</option>
                <option value="closed">closed</option>
            </select>
            <p><button class="btn" type="submit">保存</button></p>
        </form>
    </div>

    <div class="panel">
        <h2>商家列表</h2>
        <table>
            <tr><th>ID</th><th>名称</th><th>电话</th><th>地址</th><th>状态</th><th>操作</th></tr>
            <% for (Merchant item : merchants) { %>
            <tr>
                <td><%=item.getId()%></td>
                <td><%=item.getName()%></td>
                <td><%=item.getPhone()%></td>
                <td><%=item.getAddress()%></td>
                <td><%=item.getStatus()%></td>
                <td>
                    <a href="<%=request.getContextPath()%>/admin/merchants?action=edit&id=<%=item.getId()%>">编辑</a>
                    |
                    <a href="<%=request.getContextPath()%>/admin/merchants?action=delete&id=<%=item.getId()%>" onclick="return confirm('确认删除？')">删除</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>
