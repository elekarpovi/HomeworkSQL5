use semimar_4;

/*1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
город и пол), которые не старше 20 лет.*/

CREATE OR REPLACE VIEW  users_below_20 AS
SELECT firstname, lastname, gender, hometown FROM users
JOIN profiles ON users.id = profiles.user_id WHERE YEAR(birthday) < "2002";

SELECT * FROM users_below_20;

/*2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK)*/

SELECT firstname, lastname, Count,
dense_rank()  OVER w AS 'Rank'
FROM users
JOIN
(SELECT from_user_id, COUNT(from_user_id) AS Count 
FROM messages
GROUP BY from_user_id
) AS mes_stat ON users.id = mes_stat.from_user_id 
WINDOW w AS (ORDER BY Count DESC)
;

/*3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
списка. (используйте LEAD или LAG)*/

SELECT *,
LAG(created_at, 1, 0) OVER (ORDER BY created_at) AS previous_m_date,
LEAD(created_at, 1, 0) OVER (ORDER BY created_at) AS next_m_date
FROM messages
ORDER BY created_at;