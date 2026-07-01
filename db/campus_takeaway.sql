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
('夜宵窗口', '炒饭、炸串、面食', '0411-100003', '学生公寓北门', 'open', 4.3),
('二食堂米饭工坊', '盖浇饭、套餐、热汤，适合午晚餐快速点单', '0411-200001', '二食堂一楼东侧', 'open', 4.5),
('清晨早餐铺', '包子、粥、豆浆、鸡蛋饼，早八前快速取餐', '0411-200002', '教学楼A区旁', 'open', 4.2),
('川湘小炒', '香辣小炒、米饭套餐、下饭热菜', '0411-200003', '三食堂二楼', 'open', 4.7),
('轻食能量站', '沙拉、全麦卷、低脂餐，适合健身和控卡人群', '0411-200004', '体育馆南门', 'open', 4.4),
('甜品研究所', '蛋糕、布丁、双皮奶、下午茶甜品', '0411-200005', '图书馆西侧商业街', 'open', 4.6),
('咖啡自习室', '咖啡、拿铁、气泡饮，适合自习续航', '0411-200006', '创新楼一楼大厅', 'open', 4.9),
('深夜拌面局', '拌面、炒面、夜宵小食，晚间供应', '0411-200007', '学生公寓南门', 'open', 4.1);

INSERT INTO users(username, password, real_name, phone, role, merchant_id) VALUES
('一食堂简餐', '123456', '一食堂简餐', '0411-100001', 'merchant', 1),
('奶茶小站', '123456', '奶茶小站', '0411-100002', 'merchant', 2),
('夜宵窗口', '123456', '夜宵窗口', '0411-100003', 'merchant', 3),
('二食堂米饭工坊', '123456', '二食堂米饭工坊', '0411-200001', 'merchant', 4),
('清晨早餐铺', '123456', '清晨早餐铺', '0411-200002', 'merchant', 5),
('川湘小炒', '123456', '川湘小炒', '0411-200003', 'merchant', 6),
('轻食能量站', '123456', '轻食能量站', '0411-200004', 'merchant', 7),
('甜品研究所', '123456', '甜品研究所', '0411-200005', 'merchant', 8),
('咖啡自习室', '123456', '咖啡自习室', '0411-200006', 'merchant', 9),
('深夜拌面局', '123456', '深夜拌面局', '0411-200007', 'merchant', 10);

INSERT INTO categories(name, description) VALUES
('主食', '米饭、面食、套餐'),
('饮品', '奶茶、果茶、咖啡'),
('小吃', '炸物、甜品、夜宵'),
('套餐', '荤素搭配、米饭套餐、多人组合'),
('早餐', '包子、粥、饼类和热饮'),
('甜品', '蛋糕、布丁、奶制甜品'),
('轻食', '沙拉、低脂餐、全麦卷'),
('夜宵', '拌面、烧烤、炸物和晚间小食'),
('咖啡', '美式、拿铁、冷萃和气泡饮');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status, score) VALUES
(1, 1, '照烧鸡腿饭', 16.80, '', '鸡腿鲜嫩，配时蔬和米饭', 80, 'on', 4.7),
(1, 1, '番茄牛腩饭', 19.90, '', '酸甜番茄汤汁配牛腩', 50, 'on', 4.5),
(2, 2, '珍珠奶茶', 9.90, '', '经典奶茶，甜度可备注', 120, 'on', 4.8),
(2, 2, '满杯水果茶', 12.80, '', '多种水果混合茶底', 90, 'on', 4.6),
(3, 3, '香辣炸串拼盘', 18.80, '', '适合夜宵分享', 60, 'on', 4.4),
(3, 1, '火腿蛋炒饭', 13.50, '', '现炒热卖', 70, 'on', 4.2),
(4, 4, '黑椒鸡排饭', 17.80, '', '黑椒汁配煎鸡排，附时蔬和米饭', 90, 'on', 4.5),
(4, 4, '咖喱牛肉饭', 21.90, '', '咖喱浓郁，牛肉软烂，午餐人气套餐', 70, 'on', 4.6),
(4, 1, '鱼香肉丝盖饭', 15.80, '', '酸甜微辣，配米饭和例汤', 80, 'on', 4.3),
(5, 5, '鲜肉小笼包', 7.00, '', '一笼六只，早晨现蒸', 150, 'on', 4.2),
(5, 5, '皮蛋瘦肉粥', 8.50, '', '热粥慢熬，适合早餐和夜间加餐', 100, 'on', 4.1),
(5, 5, '鸡蛋灌饼', 6.80, '', '酥脆饼皮，支持加肠加菜', 120, 'on', 4.0),
(6, 1, '麻婆豆腐饭', 14.80, '', '经典川味，麻辣下饭', 85, 'on', 4.7),
(6, 4, '小炒黄牛肉', 24.80, '', '鲜辣开胃，搭配米饭更合适', 55, 'on', 4.8),
(6, 4, '酸辣土豆丝', 9.90, '', '清爽酸辣，平价热菜', 100, 'on', 4.4),
(7, 7, '鸡胸肉藜麦沙拉', 19.80, '', '鸡胸肉、藜麦、生菜和低脂酱汁', 60, 'on', 4.4),
(7, 7, '牛油果全麦卷', 16.80, '', '全麦饼皮，搭配牛油果和鸡蛋', 50, 'on', 4.3),
(7, 7, '低脂酸奶碗', 13.80, '', '酸奶、燕麦和时令水果组合', 65, 'on', 4.2),
(8, 6, '芒果千层', 15.80, '', '奶油轻盈，芒果果肉丰富', 45, 'on', 4.6),
(8, 6, '焦糖布丁', 9.90, '', '焦糖香气浓郁，口感细腻', 80, 'on', 4.5),
(8, 6, '双皮奶', 8.80, '', '奶香顺滑，冷热均可', 70, 'on', 4.4),
(9, 9, '冰美式', 10.00, '', '清爽提神，适合自习和早课', 120, 'on', 4.8),
(9, 9, '燕麦拿铁', 16.00, '', '燕麦奶搭配意式浓缩，口感柔和', 90, 'on', 4.9),
(9, 9, '青柠气泡咖啡', 18.00, '', '青柠气泡水与咖啡融合，夏季推荐', 60, 'on', 4.7),
(10, 8, '葱油拌面', 11.80, '', '葱香浓郁，夜宵经典款', 100, 'on', 4.1),
(10, 8, '老干妈炒面', 13.80, '', '微辣咸香，晚间供应稳定', 80, 'on', 4.2),
(10, 3, '炸鸡小食盒', 16.80, '', '鸡块、薯条和蘸酱组合', 70, 'on', 4.3);

UPDATE dishes SET image_url = 'assets/images/dishes/staple.jpg' WHERE category_id = 1;
UPDATE dishes SET image_url = 'assets/images/dishes/drink.jpg' WHERE category_id = 2;
UPDATE dishes SET image_url = 'assets/images/dishes/snack.jpg' WHERE category_id = 3;
UPDATE dishes SET image_url = 'assets/images/dishes/setmeal.jpg' WHERE category_id = 4;
UPDATE dishes SET image_url = 'assets/images/dishes/breakfast.jpg' WHERE category_id = 5;
UPDATE dishes SET image_url = 'assets/images/dishes/dessert.jpg' WHERE category_id = 6;
UPDATE dishes SET image_url = 'assets/images/dishes/salad.jpg' WHERE category_id = 7;
UPDATE dishes SET image_url = 'assets/images/dishes/night.jpg' WHERE category_id = 8;
UPDATE dishes SET image_url = 'assets/images/dishes/coffee.jpg' WHERE category_id = 9;

INSERT INTO addresses(user_id, receiver_name, phone, detail, is_default) VALUES
(2, '张同学', '13900000000', '3号宿舍楼 502', 1);

INSERT INTO announcements(title, content) VALUES
('欢迎使用校园外卖系统', '学生可浏览菜品、加入购物车并提交订单，管理员可维护商家、菜品和订单。'),
('配送提示', '请填写准确宿舍楼和联系电话，方便骑手联系。');
