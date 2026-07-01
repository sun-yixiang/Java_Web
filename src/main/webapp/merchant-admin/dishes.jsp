<%@ page import="java.util.*,com.campus.takeaway.model.*,com.campus.takeaway.util.StatusText" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Merchant merchant = (Merchant) request.getAttribute("merchant");
    List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Dish dish = (Dish) request.getAttribute("dish");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商家菜品管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css?v=20260626">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=20260626">
</head>
<body class="admin-page merchant-admin-page">
<div class="admin-topbar">
    <div class="admin-brand">
        商家运营后台
        <small><%=merchant == null ? "菜品目录维护" : merchant.getName()%></small>
    </div>
    <div class="admin-nav" data-nav-slider data-nav-key="merchant-nav">
        <span class="nav-indicator"></span>
        <a href="<%=request.getContextPath()%>/merchant-admin/dashboard">首页</a>
        <a class="active" href="<%=request.getContextPath()%>/merchant-admin/dishes">菜品管理</a>
        <a href="<%=request.getContextPath()%>/merchant-admin/orders">订单管理</a>
        <a class="logout-link" href="<%=request.getContextPath()%>/logout">退出</a>
    </div>
</div>

<main class="admin-container">
    <section class="admin-panel">
        <div class="admin-section-title">
            <h2><%=dish == null ? "新增菜品" : "编辑菜品"%></h2>
            <span>仅维护当前商家的菜品</span>
        </div>
        <form action="<%=request.getContextPath()%>/merchant-admin/dishes" method="post">
            <input type="hidden" name="id" value="<%=dish == null ? "" : dish.getId()%>">
            <div class="admin-form-grid">
                <div>
                    <label>菜品分类</label>
                    <select name="categoryId">
                        <% for (Category category : categories) { %>
                        <option value="<%=category.getId()%>" <%=dish != null && dish.getCategoryId() == category.getId() ? "selected" : ""%>><%=category.getName()%></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label>菜品名称</label>
                    <input name="name" value="<%=dish == null ? "" : dish.getName()%>" required>
                </div>
                <div>
                    <label>价格</label>
                    <input name="price" type="number" step="0.01" min="0" value="<%=dish == null ? "" : dish.getPrice()%>" required>
                </div>
                <div>
                    <label>库存</label>
                    <input name="stock" type="number" min="0" value="<%=dish == null ? "0" : dish.getStock()%>" required>
                </div>
                <div>
                    <label>菜品评分</label>
                    <input name="score" type="number" min="0" max="5" step="0.1" value="<%=dish == null || dish.getScore() == null ? "0.0" : dish.getScore()%>" required>
                </div>
                <div>
                    <label>状态</label>
                    <select name="status">
                        <option value="on" <%=dish != null && "on".equals(dish.getStatus()) ? "selected" : ""%>>已上架</option>
                        <option value="off" <%=dish != null && "off".equals(dish.getStatus()) ? "selected" : ""%>>已下架</option>
                    </select>
                </div>
                <div class="full">
                    <label>图片地址</label>
                    <input name="imageUrl" value="<%=dish == null ? "" : dish.getImageUrl()%>">
                </div>
                <div class="full">
                    <label>描述</label>
                    <input name="description" value="<%=dish == null ? "" : dish.getDescription()%>">
                </div>
            </div>
            <p><button class="btn" type="submit">保存菜品</button></p>
        </form>
    </section>

    <section class="admin-panel">
        <div class="admin-section-title">
            <h2>本店菜品</h2>
            <span>共 <%=dishes.size()%> 道</span>
        </div>
        <div class="admin-table-wrap">
            <table>
                <tr><th>ID</th><th>名称</th><th>分类</th><th>价格</th><th>库存</th><th>评分</th><th>状态</th><th>操作</th></tr>
                <% for (Dish item : dishes) { %>
                <tr>
                    <td><%=item.getId()%></td>
                    <td><%=item.getName()%></td>
                    <td><%=item.getCategoryName()%></td>
                    <td>￥<%=item.getPrice()%></td>
                    <td><%=item.getStock()%></td>
                    <td><span class="admin-badge admin-score">评分 <%=item.getScore() == null ? "0.0" : item.getScore()%></span></td>
                    <td><span class="admin-badge admin-status-<%=item.getStatus()%>"><%=StatusText.dish(item.getStatus())%></span></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/merchant-admin/dishes?action=edit&id=<%=item.getId()%>">编辑</a>
                        |
                        <a href="<%=request.getContextPath()%>/merchant-admin/dishes?action=delete&id=<%=item.getId()%>" onclick="return confirm('确认删除？')">删除</a>
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
