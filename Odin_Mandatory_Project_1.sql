
show databases;
use mavenmovies;

show tables;

-- Q.1 Write a SQL query to count the number of characters except the spaces for each actor. 
-- Return first 10 actors name length along with their name.
select * from actor;

select concat(first_name,' ', last_name) full_name , length(first_name) + length(last_name) total_length 
from actor limit 10;

 -- Q.2  list all oscar awadees who has recieved Oscar and their name with length.
 select * from actor_award;
 select concat(first_name, ' ' , last_name)  , length(first_name) + length (last_name) total_len, awards 
 from actor_award where awards like '%Oscar%';
 
 -- Q.3 actors who acted in ‘Frost Head’.
 select * from film;
 select * from actor;
 select * from film_actor;
 
 select distinct title, first_name, last_name from film join  film_actor 
 on film_actor.film_id = film.film_id 
 join actor_award on film_actor.actor_id = actor_award.actor_id
 where title = 'Frost Head';
 
 -- Q.4 all the films acted by Will Wilson.  
 -- answer: total 31 films acted by Will wilson.
 select * from film;
 select * from actor;
 select * from film_actor;

 select distinct title from film join  film_actor 
 on film_actor.film_id = film.film_id join actor 
 on actor.actor_id = film_actor.actor_id
 where actor.first_name = 'Will' and actor.last_name = 'Wilson';
 
 -- Q.5 all the films which were rented and return in may :
 -- answer : total 326 all distinct film were rented and returned in may 
 select * from film;
 select * from inventory;
 select * from rental;
 select distinct film.title from film join inventory 
 on inventory.film_id = film.film_id join rental 
 on rental.inventory_id = inventory.inventory_id
 where month(rental_date) = 5 and month(return_date) = 5;
 
 -- Q.6 all the films with category 'Comedy'
 -- answer : total 58 films fall in category 'Comedy'
 
 select category_id from category where name = 'Comedy';
 -- category_id = 5 for Comedy
 select distinct title from film join film_category 
 on film_category.film_id = film.film_id 
 where category_id = 5;