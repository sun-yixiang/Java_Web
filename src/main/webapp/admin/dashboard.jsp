<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>后台首页</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="brand">外卖后台管理</div>
    <div class="nav">
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
        <a href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
        <a href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>
<div class="container">
    <h2>数据概览</h2>
    <div class="stats">
        <div class="stat"><strong><%=request.getAttribute("merchantCount")%></strong>商家数量</div>
        <div class="stat"><strong><%=request.getAttribute("dishCount")%></strong>菜品数量</div>
        <div class="stat"><strong><%=request.getAttribute("orderCount")%></strong>订单数量</div>
    </div>
</div>
</body>
</html>
