CREATE DATABASE IF NOT EXISTS campus_takeaway DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_takeaway;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS announcements;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'student',
    merchant_id INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE merchants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'open',
    score DECIMAL(2,1) NOT NULL DEFAULT 0.0
);

ALTER TABLE users
    ADD CONSTRAINT fk_users_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE dishes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    merchant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    description VARCHAR(255),
    stock INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'on',
    score DECIMAL(2,1) NOT NULL DEFAULT 0.0,
    CONSTRAINT fk_dishes_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id),
    CONSTRAINT fk_dishes_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    receiver_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    detail VARCHAR(255) NOT NULL,
    is_default TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'created',
    remark VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_orders_address FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    dish_id INT NOT NULL,
    dish_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_items_dish FOREIGN KEY (dish_id) REFERENCES dishes(id)
);

CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    merchant_id INT NOT NULL,
    order_id INT,
    rating INT NOT NULL,
    content VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_reviews_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id),
    CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE announcements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    content VARCHAR(500) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users(username, password, real_name, phone, role) VALUES
('admin', 'admin123', '系统管理员', '13800000000', 'admin'),
('student', '123456', '张同学', '13900000000', 'student');

INSERT INTO merchants(name, description, phone, address, status, score) VALUES
('一食堂简餐', '米饭套餐、盖浇饭、汤品', '0411-100001', '一食堂一楼', 'open', 4.6),
('奶茶小站', '奶茶、果茶、咖啡', '0411-100002', '图书馆东侧', 'open', 4.8),
('夜宵窗口', '炒饭、炸串、面食', '0411-100003', '学生公寓北门', 'open', 4.3);

INSERT INTO users(username, password, real_name, phone, role, merchant_id) VALUES
('一食堂简餐', '123456', '一食堂简餐', '0411-100001', 'merchant', 1),
('奶茶小站', '123456', '奶茶小站', '0411-100002', 'merchant', 2),
('夜宵窗口', '123456', '夜宵窗口', '0411-100003', 'merchant', 3);

INSERT INTO categories(name, description) VALUES
('主食', '米饭、面食、套餐'),
('饮品', '奶茶、果茶、咖啡'),
('小吃', '炸物、甜品、夜宵');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status, score) VALUES
(1, 1, '照烧鸡腿饭', 16.80, '', '鸡腿鲜嫩，配时蔬和米饭', 80, 'on', 4.7),
(1, 1, '番茄牛腩饭', 19.90, '', '酸甜番茄汤汁配牛腩', 50, 'on', 4.5),
(2, 2, '珍珠奶茶', 9.90, '', '经典奶茶，甜度可备注', 120, 'on', 4.8),
(2, 2, '满杯水果茶', 12.80, '', '多种水果混合茶底', 90, 'on', 4.6),
(3, 3, '香辣炸串拼盘', 18.80, '', '适合夜宵分享', 60, 'on', 4.4),
(3, 1, '火腿蛋炒饭', 13.50, '', '现炒热卖', 70, 'on', 4.2);

INSERT INTO addresses(user_id, receiver_name, phone, detail, is_default) VALUES
(2, '张同学', '13900000000', '3号宿舍楼 502', 1);

INSERT INTO announcements(title, content) VALUES
('欢迎使用校园外卖系统', '学生可浏览菜品、加入购物车并提交订单，管理员可维护商家、菜品和订单。'),
('配送提示', '请填写准确宿舍楼和联系电话，方便骑手联系。');
