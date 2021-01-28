use shopdb;


-- выбрать все заказы конкретного пользователя
SELECT user_id,
		users.email,
		orders.id as order_id
FROM orders
JOIN users on users.id = orders.user_id
WHERE user_id = 5;

-- выбрать все товары, которые заказывал конкретный пользователь
SELECT products.name,
		users.email
FROM products
JOIN order_products ON order_products.product_id = products.id
JOIN orders ON orders.id = order_products.order_id
JOIN users ON users.id = orders.user_id
WHERE orders.user_id = 5;

-- вывести всех пользователей и кол-во денег, сколько каждый потратил в нашем магазине
SELECT `users`.`id`,
       `users`.`email`,
			 IFNULL( 
					(SELECT SUM(`order_products`.`total_price`) 
					FROM `order_products`
					JOIN `orders` ON (`orders`.`id` = `order_products`.`order_id`)
					WHERE `orders`.`user_id` = `users`.`id`
					GROUP BY `orders`.`user_id`)
			 , 0) AS `total`
FROM `users`;

-- сгруппировать все заказы по дате и вывести, сколько было покупок и на какую сумму каждый день
SELECT count(orders.id) as Quantity,
		 SUM(order_products.total_price) AS Orders_total,
		 DATE(orders.created_at) AS date
FROM order_products
JOIN orders ON (orders.id = order_products.order_id)
GROUP BY DATE(orders.created_at);

-- вывести, какую сумму тратили в магазине каждая группа пользователей
SELECT user_groups.name,
SUM((
SELECT SUM(`order_products`.`total_price`)
		FROM `order_products`
		JOIN `orders` ON (`orders`.`id` = `order_products`.`order_id`)
		WHERE `orders`.`user_id` = `users`.`id`
		GROUP BY `orders`.`user_id`
)) as Total
FROM users, user_groups
WHERE user_groups.id = users.user_group_id
GROUP BY user_groups.name;

-- запрос на создание нового товара
INSERT products(`name`, `description`, `price`, `category`) 
VALUES ('iPhone X', 'smartphone', 700, 1);

-- запрос на изменение существующего товара
UPDATE products
SET `description` = 'Телефон'
WHERE `name` = 'iPhone X';

-- запрос на удаление товара
DELETE FROM products
WHERE `name`='iPhone X';

-- запрос на изменение всех заказов, которые старше определенной даты
UPDATE orders
SET `status` = 'closed'
WHERE DATE(orders.created_at) >= '2021-01-02';

-- пример реализации запроса вывода товаров при использовании пагинации
select `name`, `price` FROM `products` 
LIMIT 3 OFFSET 0;
