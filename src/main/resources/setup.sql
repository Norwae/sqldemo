DROP SCHEMA if exists demo cascade;
create schema demo;

create table person
(
    id            uuid not null primary key default gen_random_uuid(),
    first_names   varchar,
    last_names    varchar,
    date_of_birth date not null
);

create table customer
(
    person         uuid not null primary key references person,
    customer_since date not null,
    vip            bool not null
);

create table book
(
    isbn  varchar not null primary key,
    title varchar not null
);

create table authorship
(
    author uuid    not null references person,
    book   varchar not null references book,
    primary key (author, book)
);

create table inventory
(
    id       uuid    not null primary key default gen_random_uuid(),
    book     varchar not null references book,
    acquired date    not null
);

create table lending
(
    inventory_item uuid primary key references inventory,
    lent_to        uuid references customer,
    lent_on        date not null
);

create index book_by_isbn on authorship (book);

insert into person(id, first_names, last_names, date_of_birth)
values ('d74ce294-a953-11ed-afa1-0242ac120002', 'Ansgar', 'Author', DATE '1972-12-23'),
       ('d74ce294-a953-11ed-afa1-0242ac120003', 'Andrea', 'Leser', DATE '1912-7-2'),
       ('d74ce294-a953-11ed-afa1-0242ac120004', 'Fritz', 'Leser', DATE '1999-5-9'),
       ('d74ce294-a953-11ed-afa1-0242ac120005', 'Gertraut', 'Bahldens', DATE '2000-10-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120006', 'Mia', 'Mayer', DATE '1999-11-17'),
       ('d74ce294-a953-11ed-afa1-0242ac120007', 'Karl-Uwe', 'van Klaasen', DATE '1972-12-23'),
       ('d74ce294-a953-11ed-afa1-0242ac120008', 'Kee', null, DATE '1989-9-19'),
       ('d74ce294-a953-11ed-afa1-0242ac120009', 'Paul', 'Young', DATE '1989-5-13'),
       ('d74ce294-a953-11ed-afa1-0242ac12000a', null, 'Madonna', DATE '1988-12-31'),
       ('d74ce294-a953-11ed-afa1-0242ac12000b', 'Naomi', 'Cantante', DATE '1984-8-13');

insert into customer(person, customer_since, vip)
values ('d74ce294-a953-11ed-afa1-0242ac120002', DATE '2002-2-23', true),
       ('d74ce294-a953-11ed-afa1-0242ac120003', DATE '2012-7-2', false),
       ('d74ce294-a953-11ed-afa1-0242ac120004', DATE '1999-5-9', false),
       ('d74ce294-a953-11ed-afa1-0242ac120005', DATE '2013-1-16', false),
       ('d74ce294-a953-11ed-afa1-0242ac120006', DATE '2017-5-5', false),
       ('d74ce294-a953-11ed-afa1-0242ac120007', DATE '2020-4-10', false),
       ('d74ce294-a953-11ed-afa1-0242ac120008', DATE '2003-10-11', false),
       ('d74ce294-a953-11ed-afa1-0242ac120009', DATE '2015-12-19', false),
       ('d74ce294-a953-11ed-afa1-0242ac12000b', now(), false);

insert into book (isbn, title)
values ('1234567890123', 'Spass mit Kraftsport'),
       ('1234567890124', 'Grimms Märchen'),
       ('1234567890125', 'Wie man ein Buch schreibt'),
       ('1234567890112', 'Wie man ein kein Buch schreibt'),
       ('1234671232197', 'Monitor Farm'),
       ('3292398328211', 'SQL is fun!')
;

insert into authorship(book, author)
values ('1234567890123', 'd74ce294-a953-11ed-afa1-0242ac120002'),
       ('1234567890125', 'd74ce294-a953-11ed-afa1-0242ac120003'),
       ('1234567890125', 'd74ce294-a953-11ed-afa1-0242ac120004'),
       ('1234567890112', 'd74ce294-a953-11ed-afa1-0242ac120003'),
       ('1234671232197', 'd74ce294-a953-11ed-afa1-0242ac120008'),
       ('3292398328211', 'd74ce294-a953-11ed-afa1-0242ac120008')
;

insert into inventory(id, book, acquired)
values ('d74ce294-a953-11ed-afa1-0242ac12000c', '1234567890123', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12000d', '1234567890123', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12000e', '1234567890123', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12000f', '1234567890123', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120010', '1234567890124', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120011', '1234567890124', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120012', '1234567890124', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120013', '1234567890124', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120014', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120015', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120016', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120017', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120018', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120019', '1234567890125', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001a', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001b', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001c', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001d', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001e', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12001f', '1234567890112', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120020', '1234671232197', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120021', '1234671232197', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120022', '1234671232197', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120023', '1234671232197', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120024', '1234671232197', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120025', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120026', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120027', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120028', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac120029', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002a', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002b', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002c', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002d', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002e', '3292398328211', DATE '2023-02-10'),
       ('d74ce294-a953-11ed-afa1-0242ac12002f', '3292398328211', DATE '2023-02-10')
;

insert into lending
    values
        ('d74ce294-a953-11ed-afa1-0242ac120010', 'd74ce294-a953-11ed-afa1-0242ac120007', now() - INTERVAL '10 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12002c', 'd74ce294-a953-11ed-afa1-0242ac120007', now() - INTERVAL '14 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12000c', 'd74ce294-a953-11ed-afa1-0242ac120007', now() - INTERVAL '20 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12002a', 'd74ce294-a953-11ed-afa1-0242ac120009', now() - INTERVAL '11 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12002b', 'd74ce294-a953-11ed-afa1-0242ac12000b', now() - INTERVAL '1 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12001a', 'd74ce294-a953-11ed-afa1-0242ac120002', now() - INTERVAL '10 days'),
        ('d74ce294-a953-11ed-afa1-0242ac12001b', 'd74ce294-a953-11ed-afa1-0242ac120003', now() - INTERVAL '60 days');