CREATE SCHEMA step_library_5;

SET search_path to step_library_5;

-- DDL books

CREATE TABLE books(
  isbn NUMERIC(15),
  copy_no NUMERIC(3),
  book_name VARCHAR(50) NOT NULL,
  status VARCHAR(10) NOT NULL,
  PRIMARY KEY(isbn,copy_no)
);

\SET pwd '\'':p'/data/books.csv\''
copy books FROM :pwd WITH delimiter ',';


-- DDL user

CREATE TABLE users
(
user_id VARCHAR(10) PRIMARY KEY,
 user_name VARCHAR(100) NOT NULL
);

\SET pwd '\'':p'/data/users.csv\''
copy users FROM :pwd WITH delimiter ',';

-- DDL book details

CREATE TABLE book_details(
isbn NUMERIC(15) PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 author VARCHAR(100),
 no_of_pages NUMERIC(5),
 publisher VARCHAR(100),
 description TEXT
);

\SET pwd '\'':p'/data/book_details.csv\''
copy book_details FROM :pwd WITH delimiter ',';

-- Foreign Key columns for book details table

ALTER TABLE books
ADD CONSTRAINT st_isbn
FOREIGN KEY (isbn)
REFERENCES book_details(isbn);

--  DDL library log

CREATE TABLE library_register
(
isbn NUMERIC(15) NOT NULL,
copy_no NUMERIC(5) NOT NULL,
borrowed_by VARCHAR(100),
borrow_date DATE NOT NULL,
return_date DATE
);

\SET pwd '\'':p'/data/library_register.csv\''
copy library_register FROM :pwd WITH delimiter ',';

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
