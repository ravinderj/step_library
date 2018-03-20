1 . select distinct book_name from books where status='Available';

2. select book_name from books b where copy_no =  (select max(copy_no) from books);

3. select book_name from (select book_name,count(*) from books group by book_name) b where count<=5;

4. VIEW most_borrowed_books_dec - 
select distinct book_name, count from (select isbn,count(*) from library_register where borrow_date between '2017-12-01' and '2017-12-31' group by isbn) lr join books b on lr.isbn = b.isbn;

select book_name from most_borrowed_books_dec mbb where count = (select max(count) from most_borrowed_books_dec);

5. VIEW recent_borrowed_books - 

select distinct book_name from books b join library_register l on l.isbn=b.isbn where (DATE_PART('year', now()::date) - DATE_PART('year', borrow_date::date)) * 12 +(DATE_PART('month', now()::date) - DATE_PART('month', borrow_date::date))<4;

select book_name from book_details  except (select book_name from recent_borrowed_books);


6.   VIEW recent_borrowed_books_count  - 

create view recent_borrowed_books_count as select b.book_name, b.copy_no from (select bk_detls.book_name from book_details bk_detls except (select rbb.book_name from recent_borrowed_books rbb)) bd join books b on bd.book_name = b.book_name;


select distinct book_name from recent_borrowed_books_count where copy_no>10;


7. VIEW user_log_dec - 
select borrowed_by,count(*) from library_register where borrow_date between '2017-12-01' and '2017-12-31' group by borrowed_by;

select borrowed_by from user_log_dec where count=(select max(count) from user_log_dec);

8. VIEW books_in_possesion -
select * from library_register where return_date is null and date_part('day',now()::timestamp - borrow_date::timestamp)>15;

 select distinct borrowed_by from books_in_possesion;

9.  select borrowed_by
from (select borrowed_by, count(*) from books_in_possesion group by borrowed_by) bip
where count>=2;

10. select b.book_name from books b
join books_in_demand m
on m.book_name=b.book_name
where b.status!='Available'
and m.count=(select max(count) from books_in_demand);


11. select borrowed_by from library_register where date_part('day',return_date::timestamp - borrow_date::timestamp)<=12;

12. select avg(date_part('day',return_date::timestamp - borrow_date::timestamp)) from library_register where return_date between '2018-01-01' and '2018-02-18';

