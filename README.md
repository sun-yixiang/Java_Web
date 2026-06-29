# 校园外卖点餐管理系统

这是一个 JSP + Servlet + MySQL 管理系统项目。

## 技术栈

- Java 17
- JSP / Servlet 4
- Maven
- MySQL 8
- JDBC

## 数据库表

项目包含 9 张核心表：

- users 用户表
- merchants 商家表
- categories 菜品分类表
- dishes 菜品表
- addresses 收货地址表
- orders 订单表
- order_items 订单明细表
- reviews 评价表
- announcements 公告表

## 主要功能

- 学生注册、登录、退出
- 浏览商家和菜品
- 购物车添加、修改数量、删除
- 选择地址并提交订单
- 查看我的订单
- 管理员登录
- 管理商家、分类、菜品、订单状态

## 运行步骤

1. 创建数据库并导入 `db/campus_takeaway.sql`
2. 如果需要给已有数据库追加更多演示商家和菜品，继续导入 `db/seed_more_data.sql`
3. 修改 `src/main/resources/db.properties` 中的 MySQL 用户名和密码
4. 在项目根目录执行：

```bash
mvn clean package
```

如果你的 Maven 全局配置无法创建本地仓库，可以改用项目内配置：

```bash
mvn -s .mvn/settings.xml clean package
```

5. 将 `target/campus-takeaway.war` 部署到 Tomcat 9
6. 浏览器访问：

```text
http://localhost:8080/campus-takeaway/home
```

## 测试账号

管理员：

- 用户名：admin
- 密码：admin123

学生：

- 用户名：student
- 密码：123456
