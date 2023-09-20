-- ex 12


/*
 O cerere nesincronizata care afiseaza
toti chiriasii a caror magazine nu au nicio reclamatie.
-cerere sincronizata cu cel putin 3 tabele
-clauza WITH
*/
WITH Subcerere AS (
 SELECT m.id_chirias
 FROM MAGAZIN m
 LEFT JOIN RECLAMATIE r ON m.id_magazin = r.id_magazin
 WHERE r.id_magazin IS NULL
)
SELECT c.nume_chirias
FROM CHIRIAS c
WHERE c.id_chirias IN (
 SELECT id_chirias
 FROM Subcerere
);





/*
 Afisarea tuturor magazinelor a caror mall detine o promovare, selectand
astfel numele magazinului (cu majuscule), data cand incepe campania de promovare
(in format zi-luna-an), data cand se sfarseste campania (in format an-luna-zi), verificanduse
daca este un magazin profitabil (profitul>5000), si daca are un nume lung sau scurt(sa fie de
maxim 9
caractere).
-functii cu siruri de caractere/data
-case
*/
SELECT
 UPPER(m.nume_magazin) AS nume_magazin,
 TO_CHAR(p.data_inceput, 'DD-MON-YYYY') AS data_inceput,
 TO_CHAR(p.data_sfarsit, 'YYYY-MM-DD') AS data_sfarsit,
 CASE
 WHEN m.profit_lunar > 5000 THEN 'Profitabil'
 ELSE 'Neprofitabil'
 END AS situatie_profit,
 CASE
 WHEN LENGTH(m.nume_magazin) > 9 THEN 'Nume Lung'
 ELSE 'Nume Scurt'
 END AS lungime_nume
FROM MAGAZIN m
JOIN MALL ma ON m.id_mall = ma.id_mall
JOIN PROMOVARE p ON ma.id_promovare = p.id_promovare
WHERE ma.id_promovare IS NOT NULL;












 /*
 Afisarea tuturor magazinelor care au profitul lunar mai mare de 5000.

 -Functii grup ( GROUP BY, HAVING)
*/
SELECT nume_magazin, SUM(profit_lunar) AS profit_total
FROM MAGAZIN
GROUP BY nume_magazin
HAVING SUM(profit_lunar) > 5000


 /*
 Sa se afiseze toti paznicii (id-ul, numele_angajatului)
si firma la care lucreaza care au o norma intreaga.
-subcerere nesincronizata in FROM
*/
SELECT p.id_paznic, a.nume_angajat, f.nume_firma
FROM (SELECT * FROM PAZNIC WHERE norma = 'Norma intreaga') p, FIRMA f, ANGAJAT a
WHERE p.id_firma = f.id_firma
AND p.id_angajat = a.id_angajat















/*
 Sa se afiseze toate mall-urile, cu campaniile de promovare (numele mall-ului, numele
campaniei, data de incepere, si data de sfarsit) In cazul in care mall-ul nu are campanie se
va afisa "Fara campanie",
iar la data de inceput si sfarsit "Informatie indisponibila"
*/
SELECT m.nume_mall, NVL(p.nume_campanie, 'Fara campanie') AS nume_campanie,
 DECODE(p.data_inceput, NULL, 'Informatie indisponibila', TO_CHAR(p.data_inceput, 'DDMM-YYYY')) AS data_inceput,
 DECODE(p.data_sfarsit, NULL, 'Informatie indisponibila', TO_CHAR(p.data_sfarsit, 'DDMM-YYYY')) AS data_sfarsit
FROM MALL m
LEFT JOIN PROMOVARE p ON m.id_promovare = p.id_promovare;














--ex 13



UPDATE MALL
SET nume_mall = 'Roby Mall'
WHERE id_mall IN ( SELECT m.id_mall
 FROM MALL m
 JOIN PROMOVARE p ON m.id_promovare = p.id_promovare
 WHERE p.nume_campanie = 'Campania de primavara');









UPDATE MALL
SET dimensiune = dimensiune + 100
WHERE id_mall IN ( SELECT id_mall
 FROM PROMOVARE
 WHERE data_sfarsit < TO_DATE('2023-09-01', 'YYYY-MM-DD'));









DELETE FROM PRODUS
WHERE pret < (
 SELECT AVG(pret) FROM PRODUS
)-45;










--ex 15



/*
Afisati id-ul, numele si email-ul persoanelor care au facut o reclamatie (in primavera)
in magazinele care au profitul lunar mai mare de 3000, si a caror chirias este “Jane Smith”.
*/
SELECT c.id_client, c.nume_client, c.email
FROM CLIENT c
FULL OUTER JOIN RECLAMATIE r ON c.id_client = r.id_client
FULL OUTER JOIN MAGAZIN m ON r.id_magazin = m.id_magazin
FULL OUTER JOIN CHIRIAS ch ON m.id_chirias = ch.id_chirias
WHERE r.data_ora >= TO_DATE('2023-03-01', 'YYYY-MM-DD') AND r.data_ora < TO_DATE('2023-06-01',
'YYYY-MM-DD')
 AND m.profit_lunar > 3000
 AND ch.nume_chirias = 'Jane Smith';











/*
Afisati toate magazinele care vand doar pantaloni.
*/
SELECT m.nume_magazin
FROM MAGAZIN m
JOIN STOC s ON m.id_magazin = s.id_magazin
JOIN PRODUS p ON s.id_stoc = p.id_stoc
GROUP BY m.id_magazin, m.nume_magazin
HAVING COUNT(DISTINCT p.nume_produs) = 1
AND COUNT(DISTINCT CASE WHEN p.nume_produs = 'Pantaloni' THEN p.nume_produs END) = 1;














/*
Top 3 magazine in functie de profit.
*/
SELECT *
FROM (
 SELECT m.id_magazin, m.nume_magazin, m.profit_lunar
 FROM MAGAZIN m
 ORDER BY m.profit_lunar DESC
)
WHERE ROWNUM <= 3;