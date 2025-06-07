#  PostgreSQL Questions & Answers

## ১. PostgreSQL কী?

**PostgreSQL** একটি শক্তিশালী, ওপেন-সোর্স **রিলেশনাল ডাটাবেস ম্যানেজমেন্ট সিস্টেম (RDBMS)**। এটি ANSI SQL মান মেনে চলে এবং ডেটা সঠিকভাবে সংরক্ষণ ও পরিচালনার জন্য **ACID** নীতিমালা অনুসরণ করে।

#### PostgreSQL দিয়ে আমরা কী কী করতে পারি:

- ডেটা সংরক্ষণ, হালনাগাদ, মুছে ফেলা ও অনুসন্ধান করা।
- `JOIN`, `GROUP BY`, `JSON`, `CTE`, `Window Functions` ইত্যাদি শক্তিশালী ফিচার ব্যবহার করতে পারি।
- GIS বা Location Data পরিচালনার জন্য PostGIS এর মত এক্সটেনশন ব্যবহার করতে পারি।

####  PostgreSQL এর কিছু সাধারণ ব্যবহার:

- ওয়েব ও মোবাইল এপ্লিকেশন তৈরি,
- ফিন্যান্স, স্বাস্থ্য ও রিসার্চ ডেটাবেস তৈরিতে

---

## ২. PostgreSQL-এ ডাটাবেস স্কিমার উদ্দেশ্য কী?

**স্কিমা (Schema)** হলো একটি ডেটাবেসের ভিতরে আলাদা ফোল্ডার যা টেবিল, ভিউ, ফাংশন ইত্যাদিকে গুছিয়ে রাখে। এটি ডেটাবেসে বিভিন্ন অংশ তৈরি করে যাতে একাধিক ইউজার বা অ্যাপ্লিকেশন একই ডেটাবেসে কাজ করতে পারে কোনো সমস্যা ছাড়া।

####  যেমন:

```sql
CREATE SCHEMA school;
CREATE TABLE school.students (...);
CREATE TABLE school.teachers (...);
```

এখানে `school` স্কিমার অধীনে `students` এবং `teachers` টেবিল দুইটি আলাদাভাবে সংরক্ষিত।

---

## ৩. Primary Key এবং Foreign Key কী?

**Primary Key**:

- একটি টেবিলের ইউনিক আইডেন্টিফায়ার।
- NULL ও ডুপ্লিকেট ভ্যালু থাকতে পারে না।

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
```

**Foreign Key**:

- একটি টেবিলে এমন একটি কলাম যা অন্য টেবিলের `PRIMARY KEY` এর সাথে সংযুক্ত থাকে।
- এটি রেফারেন্স বা সম্পর্ক তৈরি করে।

```sql
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id)
);
```

এখানে `courses.student_id` হলো `students.student_id` এর উপর ভিত্তি করে নির্ভরশীল।

---

### ৪. SELECT স্টেটমেন্টে WHERE ক্লজের উদ্দেশ্য কী?

`WHERE` ক্লজ ব্যবহার করে নির্দিষ্ট শর্ত অনুযায়ী ডেটা ফিল্টার করতে পারা যায়।

#### উদাহরণ:

```sql
SELECT * FROM employees WHERE department = 'HR';
```

এখানে শুধু HR ডিপার্টমেন্টের এমপ্লয়িদের রেকর্ড দেখানো হবে।

`WHERE` ছাড়া `SELECT` করলে সব রেকর্ড দেখায়, কিন্তু শর্তযুক্ত ফিল্টারিং এর জন্য `WHERE` ব্যবহার করতে হবে।

---

### ৫. LIMIT এবং OFFSET ক্লজ কী কাজে লাগে?

- `LIMIT`: কয়টি রেকর্ড দেখাবে তা নির্ধারণ করে।
- `OFFSET`: কয়টি রেকর্ড স্কিপ করবে তা বলে দেয়।

####  উদাহরণ:

```sql
SELECT * FROM students LIMIT 5 OFFSET 10;
```

এই কুয়েরিটি ১১ থেকে ১৫ নম্বর শিক্ষার্থীর তথ্য দেখাবে।

Limit এবং Offset Pagination বা Page-by-page রেজাল্ট দেখানোর জন্য খুবই গুরুত্বপূর্ণ।

---

### ৬. PostgreSQL-এ JOIN অপারেশনের গুরুত্ব কী এবং এটি কীভাবে কাজ করে?

**JOIN** ব্যবহার করে একাধিক টেবিল থেকে সম্পর্কিত ডেটা নিয়ে কাজ করা যায়। এটি **রিলেশনাল ডাটাবেসের** অন্যতম শক্তিশালী ফিচার।

#### উদাহরণ:

```sql
SELECT students.name, departments.name
FROM students
JOIN departments ON students.department_id = departments.id;
```

এখানে `students` এবং `departments` টেবিলকে `department_id` এর মাধ্যমে যুক্ত করা হয়েছে।

**JOIN-এর প্রকারভেদ:**

- `INNER JOIN`: শুধুমাত্র মিলে যাওয়া রেকর্ড
- `LEFT JOIN`: বাম টেবিলের সব রেকর্ড, ডান দিকে না মিললে `NULL`
- `RIGHT JOIN`: ডান টেবিলের সব রেকর্ড, বামে না মিললে `NULL`
- `FULL JOIN`: উভয় টেবিলের সব রেকর্ড, না মিললে `NULL`

চলো আমরা একটি **খুবই সহজ এবং প্রাসঙ্গিক উদাহরণ** দেখি — যেখানে থাকবে **Students** এবং **Clubs** টেবিল।

---

টেবিল ১: `students`

| student_id | name    |
| ---------- | ------- |
| 1          | Alice   |
| 2          | Bob     |
| 3          | Charlie |

---

টেবিল ২: `clubs`

| student_id | club_name  |
| ---------- | ---------- |
| 2          | Chess Club |
| 3          | Drama Club |
| 4          | Math Club  |

---

এখন আমরা `student_id` এর উপর ভিত্তি করে `LEFT JOIN` এবং `RIGHT JOIN` ব্যবহার করব।

- **LEFT JOIN: "সব student দেখাও, এমনকি যারা কোনো ক্লাবে নেই"**

```sql
SELECT students.name, clubs.club_name
FROM students
LEFT JOIN clubs ON students.student_id = clubs.student_id;
```

### ফলাফল:

| name    | club_name  |                          |
| ------- | ---------- | ------------------------ |
| Alice   | NULL       | ❌ Alice কোনো ক্লাবে নেই |
| Bob     | Chess Club | ✅ Bob ক্লাবে আছে        |
| Charlie | Drama Club | ✅ Charlie ক্লাবে আছে    |

✅ **সব student দেখায়**, এমনকি যদি তাদের ক্লাবে না-ও পাওয়া যায়।

---

- **RIGHT JOIN: "সব ক্লাব দেখাও, এমনকি সেই সব ক্লাবও যাদের student নেই"**

```sql
SELECT students.name, clubs.club_name
FROM students
RIGHT JOIN clubs ON students.student_id = clubs.student_id;
```

### ফলাফল:

| name    | club_name  |                              |
| ------- | ---------- | ---------------------------- |
| Bob     | Chess Club | ✅ মিলে গেছে                 |
| Charlie | Drama Club | ✅ মিলে গেছে                 |
| NULL    | Math Club  | ❌ student_id 4 তালিকায় নেই |

✅ **সব ক্লাব দেখায়**, এমনকি student তালিকায় না থাকলেও।

---

#### সারাংশ:

| JOIN টাইপ  | সবসময় কোন টেবিল রাখে  | মিল না পেলে কোথায় NULL হয় |
| ---------- | ---------------------- | --------------------------- |
| LEFT JOIN  | বাম টেবিল (`students`) | ডান টেবিল (`clubs`)         |
| RIGHT JOIN | ডান টেবিল (`clubs`)    | বাম টেবিল (`students`)      |

---

> A LEFT JOIN B আর B RIGHT JOIN A একই।

### ৭. GROUP BY ক্লজ কী এবং এটি Aggregation-এর ক্ষেত্রে কীভাবে ব্যবহৃত হয়?

`GROUP BY` ক্লজ দিয়ে আমরা ডেটা নির্দিষ্ট গ্রুপে ভাগ করতে পারি এবং প্রতিটি গ্রুপে আলাদা করে Aggregation করতে পারি।

#### উদাহরণ:

```sql
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;
```

এখানে প্রতিটি ডিপার্টমেন্টে কতজন কর্মী আছেন তা গণনা করা হয়েছে।

---

### ৮. PostgreSQL-এ COUNT(), SUM(), AVG() ফাংশন কিভাবে কাজ করে?

এই ফাংশনগুলো ব্যবহার করে ডেটার উপর গণনামূলক বিশ্লেষণ করা যায়:

| ফাংশন     | কাজ              |
| --------- | ---------------- |
| `COUNT()` | কতটি রেকর্ড আছে  |
| `SUM()`   | মানগুলোর যোগফল   |
| `AVG()`   | গড় মান হিসাব করে |

#### উদাহরণ:

```sql
SELECT COUNT(*) FROM orders;
SELECT SUM(price) FROM products;
SELECT AVG(salary) FROM employees;
```

---
