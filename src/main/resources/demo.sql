--
-- Die Grundlagen
--

-- nicht mehr wirklich case sensitive
-- aber es ist traditionell, die keywords groß zu schreiben

SeLeCt 1;

-- Wir können mit werten rechnen, und einfache Operationen ausführen
-- (Die "standardbibliothek" ist von DBMS zu DBMS etwas verschieden, aber
-- mit den basics was arithmetik, strings und ähnliches angeht ausgestattet)

SELECT 1 + 3;

-- wir können berechneten Werten namen geben


SELECT 'Hallo ' || 'Welt' as greeting;

-- und typen konvertieren

select cast('1202' as decimal) + 5.5 as number_now;


-- Eine abfrage kann mehrere Werte beinhalten
SELECT 'Mehrere', 'Werte';

-- Und funktionen aufrufen
SELECT now() + INTERVAL '1Y3D6h7m';


-- Wir können sogar ad-hoc tabellen definieren, die nicht "im Schema existieren"
-- Was vor allem bei komplexen abfragen manchmal hilfreich sein kann -
-- beispielsweise wenn gegebene Daten mit bereits gespeicherten Daten kombiniert
-- werden müßen um ein update oder insert auszuführen

SELECT name
from (values ('Albert Schweitzer', DATE '1875-01-14'),
             ('Albert Einstein', DATE '1879-03-14'),
             ('Albert Hammond', DATE '1944-05-18'),
             ('Albert ''Al'' Gore', DATE '1977-01-03')) alberts(name, dob);

SELECT 1 FROM (SELECT name, age(dob)
               from (values ('Albert Schweitzer', DATE '1875-01-14'),
                            ('Albert Einstein', DATE '1879-03-14'),
                            ('Albert Hammond', DATE '1944-05-18'),
                            ('Albert ''Al'' Gore', DATE '1977-01-03')) alberts(name, dob)
) unused;

-- Abfragen gegen ein einfaches Model - was man aus einigen basics so herleiten kann


-- Idealerweise: DB-Modell gibt nur "fakten über die Welt" wieder. Hier ein Bibliothekssystem. Das geschieht
-- in dem "skalare" (also strings, zahlen, IDs, ...) in relationen gespeichert werden

-- Tabellen:
-- Person (Mensch): Name und Geburtsdatum
-- Kunde (Mensch, der bei uns bücher leihen kann): Personen-ID, beitrittsdatum, und VIP-Status
-- Bücher (Bücher die es überhaupt gibt): ISBN und titel
-- Autorenschaft (Wer hat ein Buch geschrieben): ISBN und personen-ID
-- Bestand: ISBN und bestandsnummer, plus beschaffungsdatum
-- Verleihung: Bestandsnummer, kundennummer und ausleihdatum


select first_names, last_names
from person;

-- wie viele bücher haben wir im bestand?
select count(*)
from inventory;


-- Wie viele exemplare haben wir pro ISBN?
SELECT book, COUNT(*)
FROM inventory
group by book;

-- schon ganz gut, aber ISBNs sind unhandlich. Wie viele Exemplare haben wir ISBN,
-- aber als titel angezeigt?

select title, isbn, count(*)
from inventory,
     book
where inventory.book = book.isbn
group by isbn;

-- Welche Autoren haben wir wie oft im Bestand?
select p.first_names, p.last_names, count(*)
from authorship a
     join inventory i on a.book = i.book
     join person p on p.id = a.author
group by p.id;

-- Ausleihfristen müßen nicht explizit gespeichert werden, wir können solche Regeln auch in
-- die Abfrage codieren.

select id,
       first_names,
       last_names,
       case
           when vip then interval '10 weeks'
           when customer_since < DATE '2019-01-01' then interval '1 month'
           else '20 days' end
from customer
         join person on person = id;

-- Antworten sind "ad hoc" tabellen! Sie können in andere Anfragen geschachtelt werden. (Siehe auch oben!)

-- Vorteil ist, dass wenn sich Regeln ändern, man nicht (massendaten) anpassen muss, sondern die
-- frage danach anders stellen kann

select id,
       first_names,
       last_names,
       case
           when vip then interval '10 weeks'
           when customer_since < DATE '2019-01-01' then interval '1 month'
           when customer_since < now() - INTERVAL '2 years' then '4 weeks'
           else '20 days' end
from customer
         join person on person = id;

-- Ok, aber wer hat welches Buch ausgeliehen?

select first_names || ' ' || p.last_names as name, title
from person p
         join lending l on l.lent_to = p.id
         join inventory i on i.id = l.inventory_item
         join book b on b.isbn = i.book;


-- Richtige antwort, aber unpraktisch insofern das wir Karl-Uwe mehrfach ausgeben.
-- Wir haben nach einer Liste der Personen und ausgeliehen Buchtitel gefragt. Eigentlich
-- wollen wir aber pro person eine Liste der ausgeliehenen Titel:

select first_names || ' ' || last_names as name, array_agg(title) as lent_books
from person p
         join lending l on l.lent_to = p.id
         join inventory i on i.id = l.inventory_item
         join book b on b.isbn = i.book
group by p.id;

-- Aber was wenn wir wissen wollen, wer überfällige Bücher hat?

-- zwei fragen: Was ist überfällig? Hängt vom Kunden ab.
select person,
       now() - case
                   when vip then interval '10 weeks'
                   when customer_since < DATE '2019-01-01' then interval '1 month'
                   when customer_since < now() - INTERVAL '2 years' then '4 weeks'
                   else '20 days' end as due
from customer;

-- und die Antwort in der anderen Abfrage verwenden

select first_names || ' ' || last_names as name, array_agg(title) as overdue
from person p
         join lending l on l.lent_to = p.id
         join inventory i on i.id = l.inventory_item
         join book b on b.isbn = i.book
         join (select person,
                      now() - case
                                  when vip then interval '10 weeks'
                                  when customer_since < DATE '2019-01-01' then interval '1 month'
                                  when customer_since < now() - INTERVAL '2 years' then '4 weeks'
                                  else '20 days' end as overdue_threshold
               from customer) due_dates on due_dates.person = p.id
where l.lent_on < due_dates.overdue_threshold
group by p.id;

-- Manchmal kann es sinn machen Abfragen wie tabellen zu behandeln -> views
-- oder komplizierte funktionsketten bekannt zu machen -> functions

-- oder die sprache zu erweitern (funktions, extensions, user data types) - aber das führt zu weit