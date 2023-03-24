show databases;

use ig_clone;

show tables;
select * from comments;
select *  from follows;
select * from likes;
select * from photo_tags;
select * from photos;
select * from tags;
select * from users;


-- Q.1 Create an ER diagram or draw a schema for the given database.

-- go to Database and open Revesre Engineering 
-- We can open on local host a ER-Diagram which is called Entity -Relationship diagram which is used for better understanding of information 
-- Structural Representation of Database

-- Q.2 We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users order by created_at limit 5;

-- Q.3 To target inactive users in an email ad campaign, find the users who have never posted a photo.

select * from users where id not in (select user_id from photos);
-- total 26 are inactive Users

-- Q.4 Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
with cte as (select user_id , username, count(photo_id) as total_likes from likes l join users u on l.user_id = u.id 
group by user_id, username order by 3 desc )

select * from cte where total_likes in (select max(total_likes) from cte);
-- Both have same answer
select count(photo_id), likes.user_id from photos join likes on likes.photo_id = photos.id group by 2 order by 1 ,2 desc;


-- Q.5 The investors want to know how many times does the average user post.

create or replace view count_post1 as 
select u.id, count(p.id) as counts from users u 
join photos p on u.id = p.user_id group by 1;
select * from count_post1;
select avg(counts) from count_post1;

-- if we count photo and comment as post then it should be the result 
create or replace view count_post_comment as 
select u.id, 
sum((select count(id) from comments c where u.id = c.user_id) + 
(select count(p.id) from photos p where u.id = p.user_id))
as total_count from users u group by 1;
select avg(total_count) from count_post_comment ;

-- this is not relevant if comment and likes is considered as post then it should be counted like wise 

 create or replace view count_post2 as select count(*) as counts, u.id  from users u 
 join photos p on u.id = p.user_id 
 join comments c on c.user_id = u.id 
 join likes l on l.user_id = u.id group by 2;
 select * from count_post2;
 
 select round(avg(counts)) from count_post2;


-- Q.6 A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
select * from tags;
select * from photo_tags;

select user_id , tag_name , count(t.id) as total_count  from tags t 
join photo_tags pt on t.id = pt.tag_id 
join photos p on p.id = pt.photo_id 
group by 1,2 order by 3 desc limit 5;

-- Q.7 To find out if there are bots, find users who have liked every single photo on the site.

create or replace view bots as (select user_id, count(photo_id) as total_likes from likes 
group by 1 having count(photo_id) = (select count(id) from photos) order by 2 desc);

select user_id, username, total_likes from bots join users u on u.id = bots.user_id ;



-- Q.8 Find the users who have created instagramid in may and select top 5 newest joinees from it?

select * , month(created_at) from users where month(created_at) = 5 order by 3 desc limit 5;

-- Q.9 Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?
-- only 78 are fulfilling the all conditions (from 59,78,88)
select * from users where username regexp '^c' and username regexp '[0-9]$' 
and id in ( select user_id from photos) 
and id in (select user_id from likes ) ;

-- Q.10  Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

with cte as (select user_id , username, count(p.id) as total_photos from photos p join users u on u.id = p.user_id group by 1,2)
select * from cte where total_photos regexp '[3-5]' order by 3 desc limit 30;

