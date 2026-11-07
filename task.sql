---- Задания ----

--- задание 1
SELECT model_name FROM airliners WHERE `range` = 4200;

--- задание 2
SELECT id FROM tickets WHERE price <= 13200;

--- задание 3
SELECT side_number FROM airliners WHERE color = 'white';

--- задание 4
SELECT 'range' AS max_distance FROM airliners WHERE model_name = 'Cessna 172';

--- задание 5
SELECT id FROM trips WHERE arrival IN ('PEZ', 'MMK', 'VKO');

--- задание 6
SELECT id FROM trips WHERE departure = 'DME' AND status = 'Cancelled';

--- задание 7
SELECT model_name FROM airliners WHERE `range` BETWEEN 4200 AND 7900;

--- задание 8
SELECT id FROM clients WHERE name LIKE 'Daria%';

--- задание 9
SELECT id FROM tickets WHERE service_class <> 'Business';

--- задание 10
SELECT id, name FROM clients WHERE name LIKE 'denis S%' AND REPLACE(phone, ' ', '') IN ('77140700202', '+77140700202');

--- задание 11
SELECT id FROM clients WHERE (name LIKE '% Volkov' OR name LIKE '% Volkova') AND age BETWEEN 21 AND 25;

--- задание 12
SELECT id, price FROM tickets WHERE service_class = 'Business' AND (price < 9100 OR price > 70400);

--- задание 13
SELECT name FROM clients WHERE (id LIKE '%RCB' OR id LIKE '%FCV') AND phone NOT LIKE '+705%' AND phone NOT LIKE '705%';

--- задание 14 
SELECT side_number FROM airliners 
WHERE country <> 'Russia' 
   OR (country = 'Russia' AND production_year NOT IN (2005, 2008) AND `range` > 5000);

--- задание 15 
SELECT trip_code FROM trips 
WHERE status = 'Departed' 
  AND (arrival IN ('MQF', 'ABA') OR departure NOT IN ('PYJ', 'CNN'));

--- задание 16
SELECT id FROM tickets 
WHERE ((service_class = 'Business' AND price < 15000) OR (service_class = 'Economy' AND price > 65000))
  AND trip_id NOT IN ('VR5SF5YIWN', 'OZAO28DLFP', 'LL4S1G8PQW');


--- задание 17
SELECT id, trip_code FROM trips WHERE trip_code NOT LIKE 'FY%';

--- задание 18
SELECT trip_code FROM trips 
WHERE departure IN ('SVO', 'VKO', 'DME') AND status = 'Departed';

--- задание 19
SELECT side_number, `range` FROM airliners 
WHERE (`range` > 1000 AND `range` <= 2500) OR `range` >= 6000;

--- задание 20
SELECT id FROM tickets WHERE trip_id IS NULL;

--- задание 21
SELECT service_class FROM tickets WHERE trip_id IS NOT NULL;

--- задание 22
SELECT id FROM tickets 
WHERE service_class NOT IN ('Economy') 
  AND service_class IS NOT NULL;

--- задание 23
SELECT id FROM tickets 
WHERE id IS NOT NULL 
  AND (trip_id IS NULL OR service_class IS NULL OR price IS NULL OR client_id IS NULL);

--- задание 24
SELECT id, trip_id FROM tickets WHERE service_class NOT IN ('Economy', 'Business');

--- задание 25
SELECT client_id FROM tickets 
WHERE trip_id = 'RL6EC4YWB1' 
  AND (id IS NULL OR id NOT LIKE 'UE01H8UCJQ__');

--- задание 26
SELECT model_name,
       CASE
         WHEN `range` > 1000 AND `range` <= 2500 THEN 'short-haul'
         WHEN `range` > 2500 AND `range` <= 6000 THEN 'medium-haul'
         WHEN `range` > 6000 THEN 'long-haul'
       END AS category
FROM airliners;

--- задание 27
SELECT model_name,
       CASE
         WHEN `range` > 1000 AND `range` <= 2500 THEN 'short-haul'
         WHEN `range` > 2500 AND `range` <= 6000 THEN 'medium-haul'
         WHEN `range` > 6000 THEN 'long-haul'
         ELSE 'UNDEFINED'
       END AS category
FROM airliners;

--- задания 28
SELECT side_number,
       CASE
         WHEN production_year < 2000 THEN 'review_old'
         WHEN production_year > 2010 THEN 'no_review'
         WHEN `range` > 6000 THEN 'review_mid_long_hauI'
         WHEN `range` > 2500 AND `range` <= 6000 THEN 'review_mid_medium_hauI'
         ELSE 'review_mid_short_hauI'
       END AS review_status
FROM airliners;

--- задание 29
SELECT name, COALESCE(phone, 'UNDEFINED') AS phone FROM clients;

--- задание 30
SELECT * FROM tickets 
WHERE (service_class = 'Economy' AND price BETWEEN 10000 AND 11000)
   OR (service_class = 'PremiumEconomy' AND price BETWEEN 20000 AND 30000);

--- задание 31
SELECT id, trip_id, price FROM tickets ORDER BY price ASC;

---задание 32
SELECT id, trip_id, price FROM tickets ORDER BY price ASC, trip_id DESC, id ASC;

--- задание 33
SELECT DISTINCT model_name FROM airliners;

--- задание 34
SELECT CONCAT(name, age) AS name_with_age FROM clients ORDER BY name_with_age;

--- задание 35
SELECT id, price - 2500 AS returns FROM tickets WHERE trip_id = '87RVI5T7A2';

--- задание 36
SELECT service_class, price, price * 0.92 AS new_price FROM tickets;

--- задание 37
SELECT LENGTH(model_name) AS len_model_name FROM airliners WHERE model_name LIKE 'S%';

--- задание 38
SELECT id FROM clients WHERE LENGTH(name) BETWEEN 10 AND 13;

--- задание 39
SELECT id, CONCAT(UPPER(LEFT(name, 1)), SUBSTRING(name, 2)) AS newname FROM clients;

--- задание 40
SELECT id, REPLACE(phone, ' ', '') AS newphone FROM clients;

--- задание 41
SELECT id, 
       CONCAT(LEFT(phone, 2), REPEAT('*', LENGTH(phone) - 4), RIGHT(phone, 2)) AS phone 
FROM clients 
WHERE phone IS NOT NULL;

--- задание 42
SELECT side_number,
       CASE
         WHEN production_year < 2000 THEN 'Old'
         WHEN production_year BETWEEN 2000 AND 2010 THEN 'Mid'
         ELSE 'New'
       END AS age
FROM airliners
WHERE NOT (`range` > 10000)
ORDER BY age ASC;

--- задание 43
SELECT id, trip_id,
       CASE service_class
         WHEN 'Economy' THEN price * 0.85
         WHEN 'Business' THEN price * 0.90
         WHEN 'PremiumEconomy' THEN price * 0.80
         ELSE price
       END AS new_price
FROM tickets
WHERE trip_id IN ('LL4S1G8PQW', '0SE4S0HRRU', 'JQF04Q8I9G');

--- задание 44
SELECT trip_code AS flight FROM trips
WHERE status = 'Arrived' AND id LIKE 'Y%'
ORDER BY flight ASC;

--- задание 45
SELECT LOWER(departure) AS departure,
       LOWER(status) AS status,
       LOWER(airliner_id) AS airliner_id
FROM trips WHERE arrival = 'DME';

--- задание 46
SELECT DISTINCT name FROM clients
WHERE age > 21 AND LENGTH(name) = 13;

--- задание 47
SELECT name, COALESCE(phone, 'UNDEFINED') AS phone
FROM clients WHERE name LIKE 'Anna %' OR name LIKE '% Anna';

--- задание 48
SELECT DISTINCT arrival FROM trips
WHERE airliner_id = 305881 ORDER BY arrival ASC;

--- задание 49
SELECT id, trip_code FROM trips
WHERE airliner_id IN (305881, 473503, 603813)
ORDER BY arrival ASC, trip_code DESC;

--- задание 50
SELECT LOWER(id) AS id,
       CASE WHEN price IS NULL THEN 'UNDEFINED' ELSE 'DEFINED' END AS price_status
FROM tickets;

--- задание 51
SELECT DISTINCT c.name
FROM clients c
JOIN tickets t ON t.client_id = c.id
JOIN trips tr ON tr.id = t.trip_id
WHERE tr.airliner_id = 305881;

--- задание 52
SELECT c.name, tr.departure
FROM clients c
JOIN tickets t ON t.client_id = c.id
JOIN trips tr ON tr.id = t.trip_id
WHERE tr.status = 'Delayed';

--- задание 53
SELECT a.model_name FROM airliners a
LEFT JOIN trips tr ON tr.airliner_id = a.id
WHERE tr.id IS NULL;

--- задание 54
SELECT c.name, t.price
FROM clients c
JOIN tickets t ON t.client_id = c.id
WHERE t.service_class = 'PremiumEconomy' AND t.price <= 50000;

--- задание 55
SELECT DISTINCT c.id, c.name
FROM clients c
JOIN tickets t ON t.client_id = c.id
JOIN trips tr ON tr.id = t.trip_id
JOIN airliners a ON a.id = tr.airliner_id
WHERE a.country = 'Russia';

--- задание 56
SELECT DISTINCT c.id, c.name
FROM clients c
JOIN tickets t ON t.client_id = c.id
JOIN trips tr ON tr.id = t.trip_id
JOIN airliners a ON a.id = tr.airliner_id
WHERE a.production_year < (YEAR(CURDATE()) - c.age);

--- задание 57
SELECT MAX(t.price) AS max_price
FROM tickets t
JOIN trips tr ON tr.id = t.trip_id
WHERE tr.arrival = 'DME';

--- задание 58
SELECT COUNT(*) AS count
FROM trips tr
JOIN airliners a ON a.id = tr.airliner_id
WHERE a.color = 'white';

--- задание 59
SELECT DISTINCT c.id, c.name
FROM clients c
JOIN tickets t ON t.client_id = c.id
WHERE t.service_class = 'FirstClass';


--- задание 60
SELECT MAX(t.price) AS max_price
FROM tickets t
JOIN trips tr ON tr.id = t.trip_id
JOIN airliners a ON a.id = tr.airliner_id
WHERE a.`range` = (SELECT MAX(`range`) FROM airliners);

--- задание 61
SELECT COUNT(*) AS hope_count
FROM clients c
JOIN tickets t ON t.client_id = c.id
JOIN trips tr ON tr.id = t.trip_id
WHERE c.name LIKE 'Nadezhda%' AND tr.status = 'Departed';

--- задание 62
SELECT id, trip_id,
       CASE service_class
         WHEN 'Economy' THEN price * 0.85
         WHEN 'FirstClass' THEN price * 0.90
         ELSE price
       END AS new_price
FROM tickets
WHERE trip_id IN ('DAA22Y84O7', '41BVLBDKOH', 'VCKEGVKWW8');


--- задание 63
SELECT AVG(`range`) AS avg_range FROM airliners
WHERE model_name LIKE 'Airbus%' AND production_year >= 2008;

--- задание 64
SELECT model_name FROM airliners
GROUP BY model_name
HAVING MAX(`range`) - MIN(`range`) > 1000
ORDER BY MAX(`range`) - MIN(`range`) DESC;

--- задание 65
SELECT service_class, AVG(price) AS avg_price
FROM tickets
WHERE service_class IS NOT NULL
  AND trip_id NOT IN ('FYNDDJVU', 'FYMKPDZC')
GROUP BY service_class
ORDER BY avg_price ASC;

--- задание 66
SELECT CASE
         WHEN `range` > 1000 AND `range` <= 2500 THEN 'short-haul'
         WHEN `range` > 2500 AND `range` <= 6000 THEN 'medium-haul'
         WHEN `range` > 6000 THEN 'long-haul'
       END AS category,
       AVG(production_year) AS avg_year,
       COUNT(*) AS cnt
FROM airliners
WHERE `range` > 1000
GROUP BY category;

--- задание 67
SELECT t.client_id, t.id
FROM tickets t
JOIN (SELECT client_id, MAX(price) AS mx FROM tickets GROUP BY client_id) m
  ON m.client_id = t.client_id
WHERE t.price > 0.6 * m.mx
ORDER BY t.client_id;

--- задание 68
SELECT
  (SELECT AVG(price) FROM tickets WHERE trip_id = '8RF8OI0VFR')
  - (SELECT AVG(price) FROM tickets) AS diff;

--- задание 69
SELECT
  (SELECT AVG(t.price) FROM tickets t JOIN trips tr ON tr.id=t.trip_id
   WHERE tr.trip_code IN ('FYIHSLAA', 'FYDKIBWN'))
  - (SELECT AVG(price) FROM tickets) AS diff;

--- задание 70
SELECT side_number,
       CASE
         WHEN production_year < 2000 THEN 'Old'
         WHEN production_year BETWEEN 2000 AND 2010 THEN 'Mid'
         ELSE 'New'
       END AS age
FROM airliners
WHERE NOT (`range` > 10000)
ORDER BY age ASC;