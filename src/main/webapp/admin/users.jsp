<%@ page import="java.util.*,com.campus.takeaway.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    List<Merchant> merchants = (List<Merchant>) request.getAttribute("merchants");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        外卖后台管理
        <small>平台账号管理</small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="admin-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/admin/dashboard">首页</a>
        <a href="<%=request.getContextPath()%>/admin/merchants">商家管理</a>
        <a class="active" href="<%=request.getContextPath()%>/admin/users">用户管理</a>
        <a href="<%=request.getContextPath()%>/admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>新增账号</h2>
            <span>商家账号需要绑定对应商家</span>
        </div>
        <% if (error != null) { %>
        <div class="admin-alert error"><%=error%></div>
        <% } %>
        <form action="<%=request.getContextPath()%>/admin/users" method="post">
            <div class="admin-form-grid">
                <div>
                    <label>用户名</label>
                    <input name="username" required>
                </div>
                <div>
                    <label>密码</label>
                    <input name="password" required>
                </div>
                <div>
                    <label>姓名/店铺联系人</label>
                    <input name="realName" required>
                </div>
                <div>
                    <label>联系电话</label>
                    <input name="phone">
                </div>
                <div>
                    <label>账号身份</label>
                    <select name="role">
                        <option value="student">学生</option>
                        <option value="merchant">商家</option>
                        <option value="admin">管理员</option>
                    </select>
                </div>
                <div>
                    <label>绑定商家</label>
                    <select name="merchantId">
                        <% for (Merchant merchant : merchants) { %>
                        <option value="<%=merchant.getId()%>"><%=merchant.getName()%></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <p><button class="btn" type="submit">保存账号</button></p>
        </form>
    </section>

    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>用户列表</h2>
            <span>共 <%=users.size()%> 个账号</span>
        </div>
        <div class="admin-table-wrap">
            <table>
                <tr><th>ID</th><th>用户名</th><th>姓名</th><th>电话</th><th>身份</th><th>绑定商家</th></tr>
                <% for (User item : users) { %>
                <tr>
                    <td><%=item.getId()%></td>
                    <td><%=item.getUsername()%></td>
                    <td><%=item.getRealName()%></td>
                    <td><%=item.getPhone() == null ? "" : item.getPhone()%></td>
                    <td>
                        <span class="admin-badge admin-role-<%=item.getRole()%>">
                            <%="admin".equals(item.getRole()) ? "管理员" : ("merchant".equals(item.getRole()) ? "商家" : "学生")%>
                        </span>
                    </td>
                    <td><%=item.getMerchantName() == null ? "-" : item.getMerchantName()%></td>
                </tr>
                <% } %>
            </table>
        </div>
    </section>
</main>
<script src="<%=request.getContextPath()%>/assets/js/nav-slider.js?v=20260626"></script>
</body>
</html>
