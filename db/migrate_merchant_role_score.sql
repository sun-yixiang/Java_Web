USE campus_takeaway;

ALTER TABLE merchants
    ADD COLUMN score DECIMAL(2,1) NOT NULL DEFAULT 0.0;

ALTER TABLE dishes
    ADD COLUMN score DECIMAL(2,1) NOT NULL DEFAULT 0.0;

ALTER TABLE users
    ADD COLUMN merchant_id INT NULL;

ALTER TABLE users
    ADD CONSTRAINT fk_users_merchant FOREIGN KEY (merchant_id) REFERENCES merchants(id);

UPDATE merchants SET score = 4.6 WHERE name = '一食堂简餐';
UPDATE merchants SET score = 4.8 WHERE name = '奶茶小站';
UPDATE merchants SET score = 4.3 WHERE name = '夜宵窗口';

UPDATE dishes SET score = 4.7 WHERE name = '照烧鸡腿饭';
UPDATE dishes SET score = 4.5 WHERE name = '番茄牛腩饭';
UPDATE dishes SET score = 4.8 WHERE name = '珍珠奶茶';
UPDATE dishes SET score = 4.6 WHERE name = '满杯水果茶';
UPDATE dishes SET score = 4.4 WHERE name = '香辣炸串拼盘';
UPDATE dishes SET score = 4.2 WHERE name = '火腿蛋炒饭';

INSERT INTO users(username, password, real_name, phone, role, merchant_id)
SELECT m.name, '123456', m.name, m.phone, 'merchant', m.id
FROM merchants m
WHERE NOT EXISTS (
    SELECT 1 FROM users u WHERE u.username = m.name
);
