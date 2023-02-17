SeLeCt 1;

SELECT 1 + 3;

SELECT 'Hallo ' || 'Welt' as greeting;

SELECT 'Mehrere', 'Werte';

SELECT now() + INTERVAL '1Y3D6h7m';

SELECT name
from (values ('Albert Schweitzer', DATE '1875-01-14'),
             ('Albert Einstein', DATE '1879-03-14'),
             ('Albert Hammond', DATE '1944-05-18'),
             ('Albert ''Al'' Gore', DATE '1977-01-03')) alberts(name, dob);


SELECT name, age(dob)
from (values ('Albert Schweitzer', DATE '1875-01-14'),
             ('Albert Einstein', DATE '1879-03-14'),
             ('Albert Hammond', DATE '1944-05-18'),
             ('Albert ''Al'' Gore', DATE '1977-01-03')) alberts(name, dob);

SELECT book, COUNT(*)
FROM inventory
group by book;

select title, count(*)
from inventory,
     book
where inventory.book = book.isbn
group by isbn;

select trim(coalesce(p.first_names, '') || ' ' || coalesce(p.last_names, '')), count(*)
from person p
         join authorship a on p.id = a.author
         join inventory i on a.book = i.book
group by p.id;
