USE sakila;
-- Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;
-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, " ", last_name) AS 'Actor Name' FROM actor;
-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';
-- Find all actors whose last name contain the letters GEN.
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order.
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;
-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD COLUMN description BLOB;
-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP COLUMN description;
-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;
-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(*)>1;
-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name='HARPO' WHERE first_name='GROUCHO' AND last_name = 'WILLIAMS';
-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name='GROUCHO' WHERE first_name='HARPO';
-- You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.
SELECT first_name, last_name, address FROM staff s INNER JOIN address a ON a.address_id=s.address_id;
-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, SUM(amount) total FROM staff s INNER JOIN payment p ON s.staff_id=p.staff_id
WHERE payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59' GROUP BY first_name, last_name;
-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.film_id, title, COUNT(*) AS actor_count FROM film f INNER JOIN film_actor fa ON f.film_id=fa.film_id
GROUP BY film_id, title;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) FROM inventory i INNER JOIN film f ON i.film_id=f.film_id
WHERE f.title='Hunchback Impossible';
-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
SELECT c.first_name, c.last_name, SUM(p.amount) AS amount FROM payment p INNER JOIN customer c ON p.customer_id=c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY c.last_name;
-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT * FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id IN
(SELECT language_id FROM language WHERE name='English');
-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name, a.last_name FROM actor a WHERE actor_id IN 
(SELECT actor_id FROM film f INNER JOIN film_actor fa ON f.film_id = fa.film_id WHERE f.title='Alone Trip');
-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cu.first_name, cu.last_name, cu.email FROM customer cu INNER JOIN address a ON a.address_id=cu.address_id
INNER JOIN city ci ON a.city_id=ci.city_id INNER JOIN country co ON ci.country_id=co.country_id
WHERE co.country='Canada';
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.* FROM film f INNER JOIN film_category fc ON f.film_id=fc.film_id
INNER JOIN category c ON fc.category_id=c.category_id WHERE c.name='Family';
-- Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(*) AS rental_count FROM film f INNER JOIN inventory i ON f.film_id=i.film_id
INNER JOIN rental r ON r.inventory_id=i.inventory_id GROUP BY f.film_id, f.title ORDER BY COUNT(*) DESC;
-- Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) FROM payment p INNER JOIN rental r ON p.rental_id=r.rental_id
INNER JOIN inventory i ON r.inventory_id=i.inventory_id
INNER JOIN store s ON i.store_id=s.store_id GROUP BY s.store_id;
-- Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country FROM store s INNER JOIN address a ON s.address_id=a.address_id
INNER JOIN city ci ON a.city_id=ci.city_id INNER JOIN country co ON ci.country_id=co.country_id;
-- List the top five genres in gross revenue in descending order.
SELECT f.title, SUM(p.amount) AS 'gross revenue' FROM film f INNER JOIN inventory i ON f.film_id=i.film_id
INNER JOIN rental r ON r.inventory_id=i.inventory_id INNER JOIN payment p ON p.rental_id=r.rental_id
GROUP BY f.film_id, f.title ORDER BY SUM(p.amount) DESC LIMIT 5;
-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_gross_revenue AS SELECT f.title, SUM(p.amount) AS 'gross revenue'
FROM film f INNER JOIN inventory i ON f.film_id=i.film_id
INNER JOIN rental r ON r.inventory_id=i.inventory_id INNER JOIN payment p ON p.rental_id=r.rental_id
GROUP BY f.film_id, f.title ORDER BY SUM(p.amount) DESC LIMIT 5;
-- How would you display the view that you created in 8a?
SELECT * FROM top_5_gross_revenue;
-- You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_5_gross_revenue;