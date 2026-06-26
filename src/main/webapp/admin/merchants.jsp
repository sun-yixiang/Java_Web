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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商家管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        外卖后台管理
        <small>Merchant Operations</small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="admin-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a class="active" href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a href="<%=request.getContextPath()%>/admin/dishes">菜品管理</a>
        <a href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-panel">
        <div class="admin-section-title">
            <h2><%=merchant == null ? "新增商家" : "编辑商家"%></h2>
            <span>维护校内窗口与配送联系方式</span>
        </div>
        <form action="<%=request.getContextPath()%>/admin/merchants" method="post">
            <input type="hidden" name="id" value="<%=merchant == null ? "" : merchant.getId()%>">
            <div class="admin-form-grid">
                <div>
                    <label>商家名称</label>
                    <input name="name" value="<%=merchant == null ? "" : merchant.getName()%>" required>
                </div>
                <div>
                    <label>联系电话</label>
                    <input name="phone" value="<%=merchant == null ? "" : merchant.getPhone()%>">
                </div>
                <div class="full">
                    <label>商家简介</label>
                    <input name="description" value="<%=merchant == null ? "" : merchant.getDescription()%>">
                </div>
                <div>
                    <label>所在地址</label>
                    <input name="address" value="<%=merchant == null ? "" : merchant.getAddress()%>">
                </div>
                <div>
                    <label>营业状态</label>
                    <select name="status">
                        <option value="open" <%=merchant != null && "open".equals(merchant.getStatus()) ? "selected" : ""%>>open</option>
                        <option value="closed" <%=merchant != null && "closed".equals(merchant.getStatus()) ? "selected" : ""%>>closed</option>
                    </select>
                </div>
            </div>
            <p><button class="btn" type="submit">保存商家</button></p>
        </form>
    </section>

    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>商家列表</h2>
            <span>共 <%=merchants.size()%> 家</span>
        </div>
        <div class="admin-table-wrap">
            <table>
                <tr><th>ID</th><th>名称</th><th>电话</th><th>地址</th><th>状态</th><th>操作</th></tr>
                <% for (Merchant item : merchants) { %>
                <tr>
                    <td><%=item.getId()%></td>
                    <td><%=item.getName()%></td>
                    <td><%=item.getPhone()%></td>
                    <td><%=item.getAddress()%></td>
                    <td><span class="admin-badge admin-status-<%=item.getStatus()%>"><%=item.getStatus()%></span></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/admin/merchants?action=edit&id=<%=item.getId()%>">编辑</a>
                        |
                        <a href="<%=request.getContextPath()%>/admin/merchants?action=delete&id=<%=item.getId()%>" onclick="return confirm('确认删除？')">删除</a>
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
