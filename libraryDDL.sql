CREATE SCHEMA step_library;

SET search_path to step_library;

-- DDL books

CREATE TABLE books(
  isbn NUMERIC(15),
  copy_no numeric(3),
  book_name varchar(50) not null,
  status varchar(10) not null,
  PRIMARY KEY(isbn,copy_no)
);


-- DDL user

CREATE TABLE users
( 
user_id VARCHAR(10) PRIMARY KEY,
 user_name varchar(100) NOT NULL
);

-- DDL book details

CREATE TABLE book_details(
isbn Numeric(15) primary key,
 name VARCHAR(100) not null,
 author VARCHAR(100),
 publisher VARCHAR(100),
 no_of_pages NUMERIC(5),
 description TEXT
);

-- Foreign Key columns for book details table

ALTER TABLE book_details
ADD CONSTRAINT st_isbn
FOREIGN KEY (isbn) 
REFERENCES books(isbn);

—DDL library log

CREATE TABLE library_register
(
isbn Numeric(15) NOT NULL,
copy_no NUMERIC(5) not null,
borrowed_by VARCHAR(100),
borrow_date DATE,
return_date DATE
);

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

