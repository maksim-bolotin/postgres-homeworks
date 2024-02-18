-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT c.company_name AS название_компании,
       CONCAT(e.first_name, ' ', e.last_name) AS фио_сотрудника
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN employees AS e ON o.employee_id = e.employee_id
JOIN shippers AS s ON o.ship_via = s.shipper_id
WHERE c.city = 'London'
  AND e.city = 'London'
  AND s.company_name = 'United Package';


-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT
    product_name,
    units_in_stock,
    suppliers.contact_name,
    suppliers.phone
FROM products
INNER JOIN suppliers USING (supplier_id)
INNER JOIN categories USING (category_id)
WHERE
    units_in_stock < 25
    AND discontinued = 0
    AND (category_name = 'Condiments' OR category_name = 'Dairy Products')
ORDER BY units_in_stock;


-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT company_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);


-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT DISTINCT product_name
FROM products
WHERE product_id = ANY (
    SELECT product_id
    FROM order_details
    WHERE quantity = 10
);
