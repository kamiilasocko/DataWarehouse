-- zadanie 1
-- Na podstawie dostarczonych danych prosz� wyznaczy� �redni� kwot� zam�wienia w dniu 18 Lutego 2015
WITH ex1 AS(
SELECT od.[order_details_id]
      ,od.[order_id]
      ,od.[pizza_id]
      ,od.[quantity]
	  ,p.price * od.quantity summarized_priced
	  ,o.date AS order_date
  FROM [dbo].[order_details] od
  JOIN pizzas p ON p.pizza_id = od.pizza_id
  JOIN orders o ON o.order_id = od.order_id
  WHERE o.date = '2015-02-18'
 )

SELECT avg(summarized_priced) AS avg_order_price, order_date
FROM ex1
GROUP BY order_date



-- zadanie 2
-- Pizzeria planuje wdro�enie programu lojalno�ciowego dla klient�w kt�rzy nigdy nie zam�wili 
-- pizzy z ananASem w Marcu 2015. Prosz� o stworzenie tabeli z id takich zam�wie�. (przydatna funkcja string_agg)

WITH ex2 AS(
SELECT STRING_AGG(pt.ingredients,',') ing
	,od.[order_id]
  FROM [cwiczenia1].[dbo].[order_details] od
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
  JOIN orders o ON o.order_id = od.order_id
  WHERE o.date LIKE '2015-03-%'
  GROUP BY od.[order_id]
)

SELECT order_id
FROM ex2 
WHERE (ing NOT LIKE '%Pineapple%')



-- zadanie 3
-- Pizzeria planuje nagrodzi� klient�w o najwy�szych zam�wieniach bONami kwotowymi. Prosz� 
-- przygotowa� tabel� z id 10 najwi�kszych zam�wie� dla lutego wraz z ich kwot� przy u�yciu 
-- funkcji rank () over. 

-- without rank () over

WITH ex3 AS(
SELECT od.order_id,  p.price*od.quantity summarized_price, p.price, od.quantity
  FROM [cwiczenia1].[dbo].[pizzas] p
  JOIN order_details od ON od.pizza_id = p.pizza_id
  JOIN orders o ON od.order_id = o.order_id
  WHERE o.date LIKE '%-02-%'
)

SELECT TOP 10 order_id, SUM(summarized_price) AS price FROM ex3
GROUP BY order_id
ORDER BY price desc ;

-- WITH rank_over()
WITH ex3 AS(
SELECT od.order_id, SUM(p.price*od.quantity) price, rank () over (ORDER BY SUM(p.price*od.quantity) desc) ranking 
  FROM [cwiczenia1].[dbo].[pizzas] p
  JOIN order_details od ON od.pizza_id = p.pizza_id
  JOIN orders o ON od.order_id = o.order_id
  WHERE o.date LIKE '%-02-%'
  GROUP BY od.order_id
)

SELECT order_id, price, ranking 
FROM ex3 
WHERE ranking <=10



-- zadanie 4
--Prosz� stworzy� tabel� kt�ra poka�e kwot� ka�dego zam�wienia w jednej kolumnie wraz z id 
--zam�wienia w drugiej, oraz �redniej kwocie zam�wienia dla ka�dego miesi�ca w formacie jak 
--poni�ej (w tym przypadku Common Table Expressions mog� okaza� si� szczeg�lnie 
--przydatne)

WITH first AS(
SELECT od.order_id
	,SUM(p.price*od.quantity) order_amount
	,MONTH(o.date) months
	,o.date
  FROM [cwiczenia1].[dbo].[orders] o
  JOIN order_details od ON od.order_id = o.order_id
  JOIN pizzas p ON p.pizza_id = od.pizza_id 
  GROUP BY od.order_id, o.date


 ),
 average_month_amount AS(
	SELECT avg(order_amount) average_month_amount, months 
	FROM first
	GROUP BY months
 )
SELECT f.order_id, f.order_amount, a.average_month_amount, f.date 
FROM first f
JOIN average_month_amount a 
ON f.months = a.months 


 -- zadanie 5
--Prosz� przygotowa� tabel� z list� pokazuj�c� liczb� zam�wie� dla danej pe�nej godziny w 
--dniu 1 Stycznia 2015 tak jak pooni�ej (prosz� zaokr�gla� do pe�nych godzin w d� tj. 11:59 
--b�dzie 11):

WITH ex5 AS(
SELECT o.order_id 
	,o.date
	,DATEPART(HOUR, o.time) hour
	FROM [cwiczenia1].[dbo].[orders] o
	WHERE o.date like '2015-01-01'
) 
SELECT count(order_id) order_count, date, hour 
FROM ex5 
GROUP BY hour, date

-- zadanie 6
--Prosz� wykona� tabel� z popularno�ci� danych rodzaj�w pizzy w miesi�cu Styczniu 2015. Ma 
--ONa pokazywa� ilo�� sprzedanych rodzaj�w pizz bez rozr�nienia na jej rozmiary. Tabela ma 
--zawiera� nazw� ka�dej pizzy oraz jej kategori�. 

WITH ex6_1 as(
SELECT pt.[pizza_type_id]
      ,pt.[name]
      ,pt.[category]
	  ,od.order_id
	  ,o.date as order_date
	  ,od.quantity
  FROM [cwiczenia1].[dbo].[pizza_types] pt
  JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id 
  JOIN order_details od ON od.pizza_id = p.pizza_id 
  JOIN orders o ON o.order_id = od.order_id
  WHERE o.date LIKE '2015-01-%'
 
),

ex6_2 as(
	SELECT name, category, sum(quantity) as amount
	FROM ex6_1
	GROUP BY pizza_type_id, name, category 
)

SELECT * FROM ex6_2  ORDER BY amount

-- Zadanie 7 
-- Prosz� przygotowa� tabel� kt�ra zobrazuje popularno�� ka�dego rozmiaru pizzy w miesi�cu 
-- Lutym oraz Marcu 2015 w formacie zbli�onym do tego poni�szego

-- with size column from table pizzas
WITH ex7_1 as(
	SELECT p.pizza_id
		  ,od.quantity
		  ,p.size
	  FROM [cwiczenia1].[dbo].[pizza_types] pt
	  JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id 
	  JOIN order_details od ON od.pizza_id = p.pizza_id 
	  JOIN orders o ON o.order_id = od.order_id
	  WHERE o.date LIKE '2015-02-%' OR o.date LIKE '2015-03-%'
),
ex7_2 as(
	SELECT sum(quantity) count, size 
	FROM ex7_1
	GROUP BY size
)

SELECT * FROM ex7_2

-- without usage of tables pizzas/pizza_types
WITH ex7_1 as(
	SELECT od.pizza_id
		  ,od.quantity
	  FROM order_details od
	  JOIN orders o ON o.order_id = od.order_id
	  WHERE o.date LIKE '2015-02-%' OR o.date LIKE '2015-03-%'
),
ex7_2 as(
	SELECT RIGHT(pizza_id,1) size, sum(quantity) count
	FROM ex7_1
	GROUP BY  RIGHT(pizza_id,1) 
)

SELECT * FROM ex7_2
