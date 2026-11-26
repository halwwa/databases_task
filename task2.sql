--- задание 1
DROP PROCEDURE IF EXISTS find_client;

DELIMITER //

CREATE PROCEDURE find_client(IN p_surname VARCHAR(255)) --процедура с одним параметром
BEGIN 
    SELECT c.name    AS client_name, -- вывод
           c.phone   AS client_phone,
           t.trip_id AS trip_id,
           tr.departure AS departure,
           tr.arrival   AS arrival
    FROM clients c -- основная таблица
    JOIN tickets t ON t.client_id = c.id -- присоединяем билеты
    JOIN trips   tr ON tr.id = t.trip_id -- присоединяем рес каждого билета
    WHERE c.name LIKE CONCAT('%', p_surname); -- оставляем только клиента,которого ищем
END //

DELIMITER;

CALL find_client('Volkov');

--- задание 2
DROP FUNCTION IF EXISTS calc_bonus; -- удаление старой версии, если есть

DELIMITER //

CREATE FUNCTION calc_bonus( p_surname VARCHAR(255)) --создание функции
RETURNS DECIMAL(12,2) --функция возвращает число до 12 цифр, 2 после запятой
DETERMINISTIC    -- для одинаковых результатов                                       
READS SQL DATA --функция читает данные, не меняет

BEGIN
    DECLARE v_bonus DECIMAL(12,2); -- обновляем переменную, куда будет складываться итог

    SELECT COALESCE(
        SUM( -- если баллов нет, сумма вернет ноль
            CASE 
                WHEN t.price>=20000
                THEN t.price * 0.2
                ELSE t.price * 0.1
            END

        ),
        0
    )
    INTO v_bonus --результат кладем в переменную
    FROM clients c -- таблица клиентов
    JOIN tickets t ON t.client_id = c.id --присоединяем все билеты 
    WHERE c.name LIKE CONCAT('%', p_surname); -- фильтр на фамилию
    RETURN v_bonus; --сумма результатов

END //
DELIMITER ;

SELECT calc_bonus('Volkov') AS bonus_points;

--- задание 3
drop TABLE IF EXISTS del_clients;
drop TRIGGER IF EXISTS trg_trip_delayed;

CREATE TABLE del_clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    phone VARCHAR(255),
    trip_code VARCHAR(8),
    departure VARCHAR(3),
    arrival VARCHAR(3)
);

DELIMITER // 
CREATE TRIGGER trg_trip_delayed
AFTER UPDATE 
ON trips
FOR EACH ROW 
BEGIN 
    IF NEW.status = 'Delayed' AND OLD.status != 'Delayed' THEN
        INSERT INTO delayed_passengers (name, phone, trip_code, departure, arrival)
        SELECT  NEW.trip_code,
                NEW.departure,
                NEW.arrival,
                c.name,
                c.phone,
                CONCAT('Здравствуйте', c.name, 'Ваш рейс', NEW.trip_code,
                '(', NEW.departure, '->', NEW.arrival, ') задержан.')

        FROM tickets t
        JOIN clients c ON c.id = t.client_id
        WHERE t.trip_id = NEW.id;
    END IF;
END // 
DELIMITER ;

UPDATE trips SET status = 'Delayed' WHERE trip_code = 'FYKUZEYK';
SELECT * FROM delayed_passengers;


--- задание 4
DELETE FROM tickets WHERE id LIKE 'TEST%'; 
drop TRIGGER IF EXISTS trg_ticket_purchase;

DELIMITER //
CREATE TRIGGER trg_ticket_purchase 
BEFORE INSERT ON tickets
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status
    Into v_status
    from trips
    where id = new.trip_id;

    if new.price is null then
        signal sqlstate '45000'
        set message_text = 'Оплата не прошла(price IS NULL). Покупка отменена, транзакция откачена.';
    elseif v_status = 'Cancelled' then
        signal sqlstate '45000'
        set message_text = 'Рейс отменен(Cancelled).Покупка отклонена, транзакция откачена. ';
    elseif v_status <> 'Scheduled' then                        
        signal sqlstate '45000'
        set message_text = 'Рейс не в статусе Scheduled. Продажа запрещена.';

    END IF;                                   
END //
DELIMITER ;

--- Успешная покупка
INSERT INTO tickets (id, trip_id, service_class, price, client_id)
VALUES ('TESTOK000001', 'JKRUCXH7VM', 'Economy', 15000, '3EA2CXG3P3VW');

--- Оплата не прошла
INSERT INTO tickets (id, trip_id, service_class, price, client_id)
VALUES ('TESTBAD00002', 'JKRUCXH7VM', 'Economy', NULL, '3EA2CXG3P3VW');

--- Рейс отменён 
INSERT INTO tickets (id, trip_id, service_class, price, client_id)
VALUES ('TESTBAD00003', 'JYYNPD5Q54', 'Economy', 15000, '3EA2CXG3P3VW');

--- итог
SELECT * FROM tickets WHERE id LIKE 'TEST%';

--- задание 4, через rollback

DROP PROCEDURE IF EXISTS buy_ticket;

DELIMITER //
CREATE PROCEDURE buy_ticket(
    IN t_id VARCHAR(12),
    in t_trip_id VARCHAR(10),
    in t_service_class VARCHAR(255),
    in t_price int,
    in t_client_id VARCHAR(12)
)
BEGIN
   declare v_status varchar(20);
   declare exit handler for sqlexception
   BEGIN                                                     
        ROLLBACK;                                             
        RESIGNAL;                                              
    END;

    select status into v_status
    from trips
    where id = t_trip_id;

    start transaction;

    if t_price is null then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Оплата не прошла(price IS NULL). Покупка отменена, транзакция откачена.';
    elseif v_status = 'Cancelled' then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Рейс отменен(Cancelled).Покупка отклонена, транзакция откачена. ';
    elseif v_status <> 'Scheduled' then  
        rollback;                      
        signal sqlstate '45000'
        set message_text = 'Рейс не в статусе Scheduled. Продажа запрещена.';
    else
        insert into tickets (id, trip_id, service_class, price, client_id) values (t_id, t_trip_id, t_service_class, t_price, t_client_id);
        commit;
    end if;                           

END //
DELIMITER ;