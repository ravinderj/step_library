CREATE SCHEMA step_library_5;

SET search_path to step_library_5;

-- DDL books

CREATE TABLE books(
  isbn NUMERIC(15),
  copy_no numeric(3),
  book_name varchar(50) not null,
  status varchar(10) not null,
  PRIMARY KEY(isbn,copy_no)
);

\set pwd '\'':p'/data/books.csv\''
copy books from :pwd with delimiter ',';


-- DDL user

CREATE TABLE users
(
user_id VARCHAR(10) PRIMARY KEY,
 user_name varchar(100) NOT NULL
);

\set pwd '\'':p'/data/users.csv\''
copy users from :pwd with delimiter ',';

-- DDL book details

CREATE TABLE book_details(
isbn Numeric(15) primary key,
 name VARCHAR(100) not null,
 author VARCHAR(100),
 no_of_pages NUMERIC(5),
 publisher VARCHAR(100),
 description TEXT
);

\set pwd '\'':p'/data/book_details.csv\''
copy book_details from :pwd with delimiter ',';

-- Foreign Key columns for book details table

ALTER TABLE books
ADD CONSTRAINT st_isbn
FOREIGN KEY (isbn)
REFERENCES book_details(isbn);

--  DDL library log

CREATE TABLE library_register
(
isbn Numeric(15) NOT NULL,
copy_no NUMERIC(5) not null,
borrowed_by VARCHAR(100),
borrow_date DATE,
return_date DATE
);

\set pwd '\'':p'/data/library_register.csv\''
copy library_register from :pwd with delimiter ',';

-- Foreign Key columns for library log table

ALTER TABLE library_register
ADD CONSTRAINT
st_book_id
FOREIGN KEY (isbn,copy_no)
REFERENCES books(isbn,copy_no);

ALTER TABLE library_register
ADD CONSTRAINT st_borrowed_by
FOREIGN KEY (borrowed_by)
REFERENCES users(user_id);
