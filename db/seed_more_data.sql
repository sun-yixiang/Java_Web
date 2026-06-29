USE campus_takeaway;

INSERT INTO merchants(name, description, phone, address, status)
SELECT '二食堂米饭工坊', '盖浇饭、套餐、热汤，适合午晚餐快速点单', '0411-200001', '二食堂一楼东侧', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '二食堂米饭工坊');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '清晨早餐铺', '包子、粥、豆浆、鸡蛋饼，早八前快速取餐', '0411-200002', '教学楼A区旁', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '清晨早餐铺');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '川湘小炒', '香辣小炒、米饭套餐、下饭热菜', '0411-200003', '三食堂二楼', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '川湘小炒');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '轻食能量站', '沙拉、全麦卷、低脂餐，适合健身和控卡人群', '0411-200004', '体育馆南门', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '轻食能量站');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '甜品研究所', '蛋糕、布丁、双皮奶、下午茶甜品', '0411-200005', '图书馆西侧商业街', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '甜品研究所');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '咖啡自习室', '咖啡、拿铁、气泡饮，适合自习续航', '0411-200006', '创新楼一楼大厅', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '咖啡自习室');

INSERT INTO merchants(name, description, phone, address, status)
SELECT '深夜拌面局', '拌面、炒面、夜宵小食，晚间供应', '0411-200007', '学生公寓南门', 'open'
WHERE NOT EXISTS (SELECT 1 FROM merchants WHERE name = '深夜拌面局');

INSERT INTO categories(name, description)
SELECT '套餐', '荤素搭配、米饭套餐、多人组合'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '套餐');

INSERT INTO categories(name, description)
SELECT '早餐', '包子、粥、饼类和热饮'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '早餐');

INSERT INTO categories(name, description)
SELECT '甜品', '蛋糕、布丁、奶制甜品'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '甜品');

INSERT INTO categories(name, description)
SELECT '轻食', '沙拉、低脂餐、全麦卷'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '轻食');

INSERT INTO categories(name, description)
SELECT '夜宵', '拌面、烧烤、炸物和晚间小食'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '夜宵');

INSERT INTO categories(name, description)
SELECT '咖啡', '美式、拿铁、冷萃和气泡饮'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = '咖啡');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '黑椒鸡排饭', 17.80, '', '黑椒汁配煎鸡排，附时蔬和米饭', 90, 'on'
FROM merchants m JOIN categories c ON c.name = '套餐'
WHERE m.name = '二食堂米饭工坊' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '黑椒鸡排饭');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '咖喱牛肉饭', 21.90, '', '咖喱浓郁，牛肉软烂，午餐人气套餐', 70, 'on'
FROM merchants m JOIN categories c ON c.name = '套餐'
WHERE m.name = '二食堂米饭工坊' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '咖喱牛肉饭');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '鱼香肉丝盖饭', 15.80, '', '酸甜微辣，配米饭和例汤', 80, 'on'
FROM merchants m JOIN categories c ON c.name = '主食'
WHERE m.name = '二食堂米饭工坊' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '鱼香肉丝盖饭');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '鲜肉小笼包', 7.00, '', '一笼六只，早晨现蒸', 150, 'on'
FROM merchants m JOIN categories c ON c.name = '早餐'
WHERE m.name = '清晨早餐铺' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '鲜肉小笼包');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '皮蛋瘦肉粥', 8.50, '', '热粥慢熬，适合早餐和夜间加餐', 100, 'on'
FROM merchants m JOIN categories c ON c.name = '早餐'
WHERE m.name = '清晨早餐铺' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '皮蛋瘦肉粥');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '鸡蛋灌饼', 6.80, '', '酥脆饼皮，支持加肠加菜', 120, 'on'
FROM merchants m JOIN categories c ON c.name = '早餐'
WHERE m.name = '清晨早餐铺' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '鸡蛋灌饼');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '麻婆豆腐饭', 14.80, '', '经典川味，麻辣下饭', 85, 'on'
FROM merchants m JOIN categories c ON c.name = '主食'
WHERE m.name = '川湘小炒' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '麻婆豆腐饭');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '小炒黄牛肉', 24.80, '', '鲜辣开胃，搭配米饭更合适', 55, 'on'
FROM merchants m JOIN categories c ON c.name = '套餐'
WHERE m.name = '川湘小炒' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '小炒黄牛肉');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '酸辣土豆丝', 9.90, '', '清爽酸辣，平价热菜', 100, 'on'
FROM merchants m JOIN categories c ON c.name = '套餐'
WHERE m.name = '川湘小炒' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '酸辣土豆丝');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '鸡胸肉藜麦沙拉', 19.80, '', '鸡胸肉、藜麦、生菜和低脂酱汁', 60, 'on'
FROM merchants m JOIN categories c ON c.name = '轻食'
WHERE m.name = '轻食能量站' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '鸡胸肉藜麦沙拉');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '牛油果全麦卷', 16.80, '', '全麦饼皮，搭配牛油果和鸡蛋', 50, 'on'
FROM merchants m JOIN categories c ON c.name = '轻食'
WHERE m.name = '轻食能量站' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '牛油果全麦卷');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '低脂酸奶碗', 13.80, '', '酸奶、燕麦和时令水果组合', 65, 'on'
FROM merchants m JOIN categories c ON c.name = '轻食'
WHERE m.name = '轻食能量站' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '低脂酸奶碗');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '芒果千层', 15.80, '', '奶油轻盈，芒果果肉丰富', 45, 'on'
FROM merchants m JOIN categories c ON c.name = '甜品'
WHERE m.name = '甜品研究所' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '芒果千层');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '焦糖布丁', 9.90, '', '焦糖香气浓郁，口感细腻', 80, 'on'
FROM merchants m JOIN categories c ON c.name = '甜品'
WHERE m.name = '甜品研究所' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '焦糖布丁');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '双皮奶', 8.80, '', '奶香顺滑，冷热均可', 70, 'on'
FROM merchants m JOIN categories c ON c.name = '甜品'
WHERE m.name = '甜品研究所' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '双皮奶');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '冰美式', 10.00, '', '清爽提神，适合自习和早课', 120, 'on'
FROM merchants m JOIN categories c ON c.name = '咖啡'
WHERE m.name = '咖啡自习室' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '冰美式');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '燕麦拿铁', 16.00, '', '燕麦奶搭配意式浓缩，口感柔和', 90, 'on'
FROM merchants m JOIN categories c ON c.name = '咖啡'
WHERE m.name = '咖啡自习室' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '燕麦拿铁');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '青柠气泡咖啡', 18.00, '', '青柠气泡水与咖啡融合，夏季推荐', 60, 'on'
FROM merchants m JOIN categories c ON c.name = '咖啡'
WHERE m.name = '咖啡自习室' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '青柠气泡咖啡');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '葱油拌面', 11.80, '', '葱香浓郁，夜宵经典款', 100, 'on'
FROM merchants m JOIN categories c ON c.name = '夜宵'
WHERE m.name = '深夜拌面局' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '葱油拌面');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '老干妈炒面', 13.80, '', '微辣咸香，晚间供应稳定', 80, 'on'
FROM merchants m JOIN categories c ON c.name = '夜宵'
WHERE m.name = '深夜拌面局' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '老干妈炒面');

INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status)
SELECT m.id, c.id, '炸鸡小食盒', 16.80, '', '鸡块、薯条和蘸酱组合', 70, 'on'
FROM merchants m JOIN categories c ON c.name = '小吃'
WHERE m.name = '深夜拌面局' AND NOT EXISTS (SELECT 1 FROM dishes WHERE name = '炸鸡小食盒');
