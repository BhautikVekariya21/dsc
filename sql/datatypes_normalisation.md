# MySQL Data Types and Database Normalization Complete Guide

## Table of Contents

1. [MySQL Data Types](#mysql-data-types)
2. [Database Normalization](#database-normalization)
3. [Normal Forms](#normal-forms)
4. [Database Anomalies](#database-anomalies)
5. [Advantages and Disadvantages of Normalization](#advantages-and-disadvantages-of-normalization)
6. [Normalization Example](#normalization-example)

## MySQL Data Types

### 1. Numeric Data Types

#### Integer Types

- **TINYINT**

  - Size: 1 byte
  - Range: -128 to 127 (signed), 0 to 255 (unsigned)
  - Usage: Boolean values, small counters, age

  ```sql
  age TINYINT UNSIGNED
  ```

- **SMALLINT**

  - Size: 2 bytes
  - Range: -32,768 to 32,767 (signed), 0 to 65,535 (unsigned)
  - Usage: Small numeric values, quantity

  ```sql
  quantity SMALLINT
  ```

- **MEDIUMINT**

  - Size: 3 bytes
  - Range: -8,388,608 to 8,388,607 (signed), 0 to 16,777,215 (unsigned)
  - Usage: Medium-range integers

  ```sql
  population MEDIUMINT UNSIGNED
  ```

- **INT (INTEGER)**

  - Size: 4 bytes
  - Range: -2,147,483,648 to 2,147,483,647 (signed), 0 to 4,294,967,295 (unsigned)
  - Usage: Primary keys, standard integers

  ```sql
  id INT AUTO_INCREMENT PRIMARY KEY
  ```

- **BIGINT**
  - Size: 8 bytes
  - Range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (signed)
  - Usage: Large numbers, timestamps, big counters
  ```sql
  total_revenue BIGINT
  ```

#### Decimal Types

- **DECIMAL (NUMERIC)**

  - Size: Variable
  - Precision: Exact decimal representation
  - Usage: Financial calculations, precise decimal values

  ```sql
  price DECIMAL(10,2)  -- 10 digits total, 2 after decimal
  ```

- **FLOAT**

  - Size: 4 bytes
  - Precision: Approximate, single precision
  - Usage: Scientific calculations where precision loss is acceptable

  ```sql
  temperature FLOAT(7,4)
  ```

- **DOUBLE (REAL)**
  - Size: 8 bytes
  - Precision: Approximate, double precision
  - Usage: High precision floating-point calculations
  ```sql
  coordinates DOUBLE(15,10)
  ```

### 2. String (Text) Data Types

- **CHAR**

  - Size: Fixed length (0-255 characters)
  - Storage: Right-padded with spaces
  - Usage: Fixed-length strings like country codes, status flags

  ```sql
  country_code CHAR(2)
  ```

- **VARCHAR**

  - Size: Variable length (0-65,535 characters)
  - Storage: Length prefix + actual data
  - Usage: Variable-length strings like names, descriptions

  ```sql
  name VARCHAR(100)
  ```

- **TINYTEXT**

  - Size: 0-255 characters
  - Usage: Short text strings

  ```sql
  short_description TINYTEXT
  ```

- **TEXT**

  - Size: 0-65,535 characters
  - Usage: Medium-length text content

  ```sql
  article_content TEXT
  ```

- **MEDIUMTEXT**

  - Size: 0-16,777,215 characters
  - Usage: Large text content

  ```sql
  book_content MEDIUMTEXT
  ```

- **LONGTEXT**
  - Size: 0-4,294,967,295 characters
  - Usage: Very large text content
  ```sql
  full_document LONGTEXT
  ```

### 3. Binary Data Types

- **BINARY**

  - Size: Fixed length (0-255 bytes)
  - Usage: Fixed-length binary data

  ```sql
  hash_value BINARY(32)
  ```

- **VARBINARY**

  - Size: Variable length (0-65,535 bytes)
  - Usage: Variable-length binary data

  ```sql
  encrypted_data VARBINARY(500)
  ```

- **TINYBLOB**

  - Size: 0-255 bytes
  - Usage: Small binary objects

  ```sql
  thumbnail TINYBLOB
  ```

- **BLOB**

  - Size: 0-65,535 bytes
  - Usage: Binary large objects like images, files

  ```sql
  profile_image BLOB
  ```

- **MEDIUMBLOB**

  - Size: 0-16,777,215 bytes
  - Usage: Medium-sized binary objects

  ```sql
  document_file MEDIUMBLOB
  ```

- **LONGBLOB**
  - Size: 0-4,294,967,295 bytes
  - Usage: Very large binary objects
  ```sql
  video_file LONGBLOB
  ```

### 4. Date and Time Types

- **DATE**

  - Format: YYYY-MM-DD
  - Range: 1000-01-01 to 9999-12-31
  - Usage: Birth dates, event dates

  ```sql
  birth_date DATE
  ```

- **TIME**

  - Format: HH:MM:SS
  - Range: -838:59:59 to 838:59:59
  - Usage: Time duration, time of day

  ```sql
  start_time TIME
  ```

- **DATETIME**

  - Format: YYYY-MM-DD HH:MM:SS
  - Range: 1000-01-01 00:00:00 to 9999-12-31 23:59:59
  - Usage: Timestamps, precise date-time values

  ```sql
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  ```

- **TIMESTAMP**

  - Format: YYYY-MM-DD HH:MM:SS
  - Range: 1970-01-01 00:00:01 UTC to 2038-01-19 03:14:07 UTC
  - Usage: Automatic timestamp updates

  ```sql
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ```

- **YEAR**
  - Format: YYYY or YY
  - Range: 1901 to 2155 (4-digit), 70-69 representing 1970-2069 (2-digit)
  - Usage: Year-only values
  ```sql
  graduation_year YEAR(4)
  ```

### 5. Special Data Types

- **ENUM**

  - Size: 1-2 bytes depending on number of values
  - Usage: Predefined list of values

  ```sql
  status ENUM('active', 'inactive', 'pending', 'suspended')
  ```

- **SET**

  - Size: 1-8 bytes depending on number of members
  - Usage: Multiple values from predefined list

  ```sql
  permissions SET('read', 'write', 'delete', 'admin')
  ```

- **BOOLEAN (BOOL)**

  - Actually TINYINT(1)
  - Values: 0 (FALSE) or 1 (TRUE)
  - Usage: True/false flags

  ```sql
  is_active BOOLEAN DEFAULT TRUE
  ```

- **JSON** (MySQL 5.7+)

  - Size: Variable
  - Usage: JSON documents, flexible schema data

  ```sql
  metadata JSON
  ```

- **GEOMETRY**
  - Usage: Spatial data, geographic information
  ```sql
  location GEOMETRY
  ```

## Database Normalization

Database normalization is the process of organizing data in a database to reduce redundancy and improve data integrity. It involves decomposing tables to eliminate data redundancy and undesirable characteristics like insertion, update, and deletion anomalies.

### Goals of Normalization

1. **Eliminate Redundant Data**: Reduce data duplication
2. **Ensure Data Dependencies**: Make sense logically
3. **Reduce Storage Space**: Optimize database size
4. **Prevent Data Anomalies**: Avoid inconsistencies during operations

## Normal Forms

### First Normal Form (1NF)

A table is in 1NF if:

1. Each column contains atomic (indivisible) values
2. Each column contains values of a single type
3. Each column has a unique name
4. The order of columns doesn't matter

#### Example: Converting to 1NF

**Before 1NF (Unnormalized)**
| StudentID | Name | Subjects |
|-----------|------|----------|
| 1 | John | Math, Physics, Chemistry |
| 2 | Alice | English, History |

**After 1NF**
| StudentID | Name | Subject |
|-----------|------|---------|
| 1 | John | Math |
| 1 | John | Physics |
| 1 | John | Chemistry |
| 2 | Alice | English |
| 2 | Alice | History |

### Second Normal Form (2NF)

A table is in 2NF if:

1. It is in 1NF
2. All non-key attributes are fully functionally dependent on the primary key
3. No partial dependencies exist

#### Example: Converting to 2NF

**1NF Table (with partial dependency)**
| StudentID | SubjectID | StudentName | SubjectName | Grade |
|-----------|-----------|-------------|-------------|-------|
| 1 | 101 | John | Math | A |
| 1 | 102 | John | Physics | B |
| 2 | 101 | Alice | Math | A+ |

**After 2NF (Split into multiple tables)**

**Students Table**
| StudentID | StudentName |
|-----------|-------------|
| 1 | John |
| 2 | Alice |

**Subjects Table**
| SubjectID | SubjectName |
|-----------|-------------|
| 101 | Math |
| 102 | Physics |

**Enrollments Table**
| StudentID | SubjectID | Grade |
|-----------|-----------|-------|
| 1 | 101 | A |
| 1 | 102 | B |
| 2 | 101 | A+ |

### Third Normal Form (3NF)

A table is in 3NF if:

1. It is in 2NF
2. No transitive dependencies exist
3. All non-key attributes depend only on the primary key

#### Example: Converting to 3NF

**2NF Table (with transitive dependency)**
| StudentID | StudentName | DepartmentID | DepartmentName | DepartmentHead |
|-----------|-------------|--------------|----------------|----------------|
| 1 | John | 10 | Computer Science | Dr. Smith |
| 2 | Alice | 20 | Mathematics | Dr. Johnson |

**After 3NF**

**Students Table**
| StudentID | StudentName | DepartmentID |
|-----------|-------------|--------------|
| 1 | John | 10 |
| 2 | Alice | 20 |

**Departments Table**
| DepartmentID | DepartmentName | DepartmentHead |
|--------------|----------------|----------------|
| 10 | Computer Science | Dr. Smith |
| 20 | Mathematics | Dr. Johnson |

### Boyce-Codd Normal Form (BCNF)

A table is in BCNF if:

1. It is in 3NF
2. For every functional dependency A → B, A must be a superkey

BCNF is a stricter version of 3NF that handles certain anomalies that 3NF cannot resolve.

#### Example: BCNF

**3NF Table (not in BCNF)**
| Professor | Subject | Student |
|-----------|---------|---------|
| Dr. Smith | Database | John |
| Dr. Smith | Database | Alice |
| Dr. Jones | Database | Bob |

Functional Dependencies:

- Professor, Student → Subject
- Subject, Student → Professor

**After BCNF**

**Professor_Subject Table**
| Professor | Subject |
|-----------|---------|
| Dr. Smith | Database |
| Dr. Jones | Database |

**Student_Subject Table**
| Student | Subject |
|---------|---------|
| John | Database |
| Alice | Database |
| Bob | Database |

## Database Anomalies

### 1. Insertion Anomaly

**Definition**: Inability to add data to the database due to absence of other data.

**Example**: In an unnormalized student-course table, you cannot add a new course unless at least one student is enrolled.

### 2. Update Anomaly

**Definition**: When updating data, multiple rows must be updated, leading to potential inconsistencies.

**Example**: If a professor's name is stored in multiple rows and needs to be updated, all occurrences must be changed.

### 3. Deletion Anomaly

**Definition**: Deleting a row results in loss of other valuable information.

**Example**: Deleting the last student from a course might also delete course information.

### Example of Anomalies

**Unnormalized Table**
| StudentID | StudentName | CourseID | CourseName | Professor | Grade |
|-----------|-------------|----------|------------|-----------|-------|
| 1 | John | CS101 | Database | Dr. Smith | A |
| 2 | Alice | CS101 | Database | Dr. Smith | B |
| 3 | Bob | CS102 | Algorithms | Dr. Jones | A |

**Anomalies in this table:**

1. **Insertion**: Cannot add CS103 course without a student
2. **Update**: Changing Dr. Smith's name requires multiple updates
3. **Deletion**: Removing Bob deletes CS102 course information

## Advantages and Disadvantages of Normalization

### Advantages of Normalization

1. **Reduced Data Redundancy**

   - Eliminates duplicate data storage
   - Saves storage space
   - Reduces data inconsistencies

2. **Improved Data Integrity**

   - Ensures data consistency
   - Prevents anomalies
   - Maintains referential integrity

3. **Easier Maintenance**

   - Updates require changes in fewer places
   - Reduced chance of inconsistent data
   - Simpler data validation

4. **Better Organization**

   - Logical data structure
   - Clear relationships between entities
   - Improved data understanding

5. **Reduced Storage Costs**
   - Less physical storage required
   - Improved database performance
   - Better memory utilization

### Disadvantages of Normalization

1. **Increased Complexity**

   - More tables to manage
   - Complex queries with multiple JOINs
   - Difficult for beginners to understand

2. **Performance Impact**

   - Slower query execution due to JOINs
   - More I/O operations
   - Increased CPU usage for complex queries

3. **Development Time**

   - More time to design normalized schema
   - Complex application logic
   - Additional maintenance overhead

4. **Query Complexity**
   - Multiple table JOINs required
   - Complex SQL statements
   - Harder to write ad-hoc queries

### Advantages and Disadvantages WITHOUT Normalization

#### Advantages of Denormalization

1. **Better Query Performance**

   - Fewer JOINs required
   - Faster data retrieval
   - Simpler queries

2. **Simplified Development**

   - Easier to understand table structure
   - Straightforward application logic
   - Reduced development time

3. **Better for Reporting**
   - All data in one place
   - Simplified report generation
   - Better for OLAP systems

#### Disadvantages of Denormalization

1. **Data Redundancy**

   - Duplicate data storage
   - Increased storage requirements
   - Higher storage costs

2. **Data Inconsistency**

   - Update anomalies
   - Insertion anomalies
   - Deletion anomalies

3. **Maintenance Issues**
   - Complex update operations
   - Risk of data corruption
   - Difficult data validation

## Normalization Example

Let's walk through a complete normalization example from an unnormalized table to BCNF.

### Original Unnormalized Table: Library System

**Books_Borrowed Table**
| MemberID | MemberName | MemberPhone | BookID | BookTitle | Author | PublisherID | PublisherName | PublisherAddress | BorrowDate | ReturnDate |
|----------|------------|-------------|--------|-----------|--------|-------------|---------------|------------------|------------|------------|
| 1001 | John Smith | 555-1234 | B001 | Database Systems | C.J. Date | P01 | Pearson | New York | 2024-01-15 | 2024-02-15 |
| 1001 | John Smith | 555-1234 | B002 | Data Mining | Jiawei Han | P02 | Morgan Kaufmann | San Francisco | 2024-01-20 | 2024-02-20 |
| 1002 | Alice Johnson | 555-5678 | B001 | Database Systems | C.J. Date | P01 | Pearson | New York | 2024-01-18 | 2024-02-18 |

### Step 1: First Normal Form (1NF)

The table is already in 1NF as all attributes contain atomic values.

### Step 2: Second Normal Form (2NF)

**Identify Functional Dependencies:**

- MemberID → MemberName, MemberPhone
- BookID → BookTitle, Author, PublisherID
- PublisherID → PublisherName, PublisherAddress
- MemberID, BookID → BorrowDate, ReturnDate

**Split into 2NF tables:**

**Members Table**
| MemberID | MemberName | MemberPhone |
|----------|------------|-------------|
| 1001 | John Smith | 555-1234 |
| 1002 | Alice Johnson | 555-5678 |

**Books Table**
| BookID | BookTitle | Author | PublisherID |
|--------|-----------|--------|-------------|
| B001 | Database Systems | C.J. Date | P01 |
| B002 | Data Mining | Jiawei Han | P02 |

**Publishers Table**
| PublisherID | PublisherName | PublisherAddress |
|-------------|---------------|------------------|
| P01 | Pearson | New York |
| P02 | Morgan Kaufmann | San Francisco |

**Borrowings Table**
| MemberID | BookID | BorrowDate | ReturnDate |
|----------|--------|------------|------------|
| 1001 | B001 | 2024-01-15 | 2024-02-15 |
| 1001 | B002 | 2024-01-20 | 2024-02-20 |
| 1002 | B001 | 2024-01-18 | 2024-02-18 |

### Step 3: Third Normal Form (3NF)

**Check for Transitive Dependencies:**
In the Books table: BookID → PublisherID → PublisherName, PublisherAddress

This is already resolved by having a separate Publishers table.

**Final 3NF Schema:**

**Members Table**

```sql
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL,
    MemberPhone VARCHAR(15)
);
```

**Publishers Table**

```sql
CREATE TABLE Publishers (
    PublisherID VARCHAR(10) PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL,
    PublisherAddress VARCHAR(200)
);
```

**Books Table**

```sql
CREATE TABLE Books (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(200) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    PublisherID VARCHAR(10),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);
```

**Borrowings Table**

```sql
CREATE TABLE Borrowings (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID VARCHAR(10),
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
```

### Step 4: BCNF Check

All tables are in BCNF as every determinant is a candidate key.

### Benefits Achieved Through Normalization

1. **Eliminated Redundancy**: Member and publisher information stored once
2. **Prevented Anomalies**: Can add books without borrowers, update member info once
3. **Improved Integrity**: Foreign key constraints ensure data consistency
4. **Better Organization**: Clear separation of concerns

### Sample Queries on Normalized Schema

**Find all books borrowed by a specific member:**

```sql
SELECT b.BookTitle, b.Author, br.BorrowDate, br.ReturnDate
FROM Members m
JOIN Borrowings br ON m.MemberID = br.MemberID
JOIN Books b ON br.BookID = b.BookID
WHERE m.MemberName = 'John Smith';
```

**Find all members who borrowed books from a specific publisher:**

```sql
SELECT DISTINCT m.MemberName, m.MemberPhone
FROM Members m
JOIN Borrowings br ON m.MemberID = br.MemberID
JOIN Books b ON br.BookID = b.BookID
JOIN Publishers p ON b.PublisherID = p.PublisherID
WHERE p.PublisherName = 'Pearson';
```

This normalization example demonstrates how to systematically organize data to achieve better structure, eliminate redundancy, and prevent data anomalies while maintaining the ability to reconstruct the original information through proper relationships.
