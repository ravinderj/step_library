-- 1. Show the total titles available in the library.
    SELECT DISTINCT book_name
    FROM books
    WHERE status='Available';

-- 2. Show the titles with highest number of copies.
    SELECT book_name
    FROM books b
    WHERE copy_no = ( SELECT max(copy_no) FROM books );

-- 3. Show the titles with five or less copies.
    SELECT book_name
    FROM (SELECT book_name, count(*) FROM books GROUP BY book_name) b
    WHERE count<=5;

-- 4. Show the titles borrowed the most in a given month. (Eg: Dec 2017)
    -- VIEW most_borrowed_books_dec -
    CREATE VIEW most_borrowed_books_dec
    AS SELECT DISTINCT book_name, count
    FROM (SELECT isbn, count(*)
      FROM library_register
      WHERE borrow_date
      BETWEEN '2017-12-01' and '2017-12-31'
      GROUP BY isbn) lr
    JOIN books b
    ON lr.isbn = b.isbn;

    SELECT book_name
    FROM most_borrowed_books_dec mbb
    WHERE count = (SELECT max(count)
      FROM most_borrowed_books_dec);

-- 5. Show the titles not borrowed for more than four months as of current date.
    -- VIEW recent_borrowed_books -
    CREATE VIEW recent_borrowed_books
    AS SELECT DISTINCT book_name
    FROM books b
    JOIN library_register l
    ON l.isbn=b.isbn
    WHERE (
      (DATE_PART('year', now()::date) - DATE_PART('year', borrow_date::date)) * 12) +
      (DATE_PART('month', now()::date) - DATE_PART('month', borrow_date::date)
    ) < 4;

    SELECT name
    FROM book_details
    EXCEPT (SELECT book_name FROM recent_borrowed_books);

-- 6. Show the titles with more than 10 copies and not borrowed for the last 3 months.
    -- VIEW recent_borrowed_books_count  -
    CREATE VIEW recent_borrowed_books_count
    AS SELECT b.book_name, b.copy_no
    FROM (
      SELECT bk_detls.name
      FROM book_details bk_detls
      EXCEPT (
        SELECT rbb.book_name
        FROM recent_borrowed_books rbb
      )
    ) bd
    JOIN books b
    ON bd.name = b.book_name;


    SELECT DISTINCT book_name
    FROM recent_borrowed_books_count
    WHERE copy_no > 10;

-- 7. Show the library user who borrowed the maximum books in a given period. (Eg: Dec 2017)
    -- VIEW user_log_dec -
    CREATE VIEW user_log_dec
    AS (
      SELECT borrowed_by,count(*)
      FROM library_register
      WHERE borrow_date
      BETWEEN '2017-12-01' and '2017-12-31'
      GROUP BY borrowed_by
    );

    SELECT borrowed_by
    FROM user_log_dec
    WHERE count=(SELECT max(count) FROM user_log_dec);

-- 8. Show the library user(s) who are in possession of a library book for more then 15 days.
   -- VIEW books_in_possesion -
    CREATE VIEW books_in_possesion AS (
      SELECT *
      FROM library_register
      WHERE return_date IS NULL
      AND date_part('day',now()::timestamp - borrow_date::timestamp) > 15
    );

    SELECT DISTINCT borrowed_by
    FROM books_in_possesion;

-- 9. Show the library user(s) who are in possession of more than two library books and holding atleast two of them for more then 15 days.
    SELECT borrowed_by
    FROM (
      SELECT borrowed_by, count(*)
      FROM books_in_possesion
      GROUP BY borrowed_by
    ) bip
    WHERE count>=2;

-- 10. Show the titles that are in high demand and copies not available.
    -- SELECT b.book_name
    -- FROM books b
    -- JOIN books_in_demand m
    -- ON m.book_name=b.book_name
    -- WHERE b.status!='Available'
    -- AND m.count=(SELECT max(count) FROM books_in_demand);

-- 11. Show the library users who returned books in 7 days time in a given period.
    SELECT borrowed_by
    FROM library_register
    WHERE date_part('day',return_date::timestamp - borrow_date::timestamp)<=7;

-- 12. Show the average period of holding the borrowed books that were returned in a certain period. (Eg: Jan 2018).
    SELECT avg(
      date_part('day',return_date::timestamp - borrow_date::timestamp)
    )
    FROM library_register
    WHERE return_date BETWEEN '2018-01-01' AND '2018-02-01';


-- need to analyse with respect to query no. 10
select book_name
from books b
where b.status!='Available' ;
select max(count)
from (
  select count(*)
  from library_register
  group by isbn
) s1;
(have to join both)

select b.book_name
from books b
join most_borrowed_book m
on m.book_name=b.book_name
  where b.status!='Available'
  and m.count=(select max(count) from most_borrowed_book);
