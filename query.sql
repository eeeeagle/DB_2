/* TASK 1 */
SELECT title, description FROM film
WHERE description LIKE "%Epic%";

/* TASK 2 */
SELECT DISTINCT first_name FROM actor
ORDER BY first_name asc;

/* TASK 3 */
SELECT first_name, last_name, country FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country.country_id = 80;

/* TASK 4 */
SELECT title, name FROM film
join film_actor ON film_actor.film_id = film.film_id
join film_category ON film_category.film_id = film.film_id
join category ON category.category_id = film_category.category_id
WHERE film_actor.actor_id = 4;

/* TASK 5 */
SELECT name, SUM(amount) AS cash FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY cash DESC LIMIT 10;

/* TASK 6 */
SELECT first_name, last_name, count(rental.rental_id) FROM customer
JOIN rental ON customer.customer_id = rental.customer_id 
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_actor ON film_actor.film_id = film.film_id
WHERE film_actor.actor_id = 3
GROUP BY customer.customer_id
ORDER BY count(rental_id) DESC LIMIT 5 OFFSET 10;

/* TASK 7 */
SELECT store.store_id, city.city, country.country, SUM(amount) as first_week_cash FROM store
JOIN address ON address.address_id = store.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
JOIN staff ON staff.store_id = store.store_id
JOIN payment ON payment.staff_id = staff.staff_id
WHERE payment.payment_date <= DATE_ADD((select MIN(payment_date) from payment), INTERVAL 1 WEEK)
GROUP BY store_id;

/* TASK 8 */
SELECT film.title, actor.first_name, actor.last_name FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
JOIN (
	SELECT film.film_id, SUM(amount) AS cash
    FROM payment
    join rental on payment.rental_id = rental.rental_id
    join inventory on inventory.inventory_id = rental.inventory_id
    join film on film.film_id = inventory.film_id
    GROUP BY film.film_id 
    ORDER BY cash DESC 
    LIMIT 1
)  AS top_film ON film.film_id = top_film.film_id;

/* TASK 9 */
SELECT 
    customer.first_name AS customer_first_name, 
    customer.last_name AS customer_last_name,
    actor.first_name AS actor_first_name,
    actor.last_name AS actor_last_name
FROM customer
LEFT JOIN actor ON customer.last_name = actor.last_name
ORDER BY customer.last_name, customer.first_name;

/* TASK 10 */
SELECT 
	actor.first_name AS actor_first_name,
    actor.last_name AS actor_last_name,
    customer.first_name AS customer_first_name, 
    customer.last_name AS customer_last_name
FROM actor 
RIGHT JOIN customer ON customer.last_name = actor.last_name
ORDER BY actor.first_name, actor.last_name DESC;

/* TASK 11 */
WITH f_l AS (
	SELECT length, count(title) FROM film
	WHERE length = (SELECT max(length) FROM film) 
    GROUP BY length
	UNION 
	SELECT length, count(title) FROM film
	WHERE length = (SELECT min(length) FROM film) 
    GROUP BY length
), 
count_a AS ( 
	WITH g_f AS (
		SELECT film_id, count(film_id) AS count_a FROM film_actor 
        GROUP BY film_id
        )
	SELECT count_a, count(film_id) FROM g_f
	WHERE count_a IN (SELECT max(count_a) FROM g_f) 
    GROUP BY count_a
	UNION
	SELECT count_a, count(film_id) FROM g_f
	WHERE count_a IN (SELECT min(count_a) FROM g_f) 
    GROUP BY count_a
)
SELECT * FROM f_l, count_a LIMIT 1, 2;