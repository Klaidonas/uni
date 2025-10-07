-- 1 LABORATORINIS

-- 1. Parašykite užklausą visai informacijai iš SALGRADE lentelės gauti.
SELECT * 
FROM SALGRADE;

-- 2. Parašykite užklausą visai informacijai iš EMP lentelės gauti.
SELECT * 
FROM EMP;

-- 3. Pateikite darbuotojų, gaunančių atlyginimą nuo 1600 iki 3000, sąrašą 
--    (pavardė, skyriaus numeris, atlyginimas).
SELECT ENAME AS SURNAME, DEPTNO, SAL
FROM EMP
WHERE SAL BETWEEN 1600 AND 3000
ORDER BY ENAME;

-- 4. Pateikite skyrių numerių ir pavadinimų sąrašą, surūšiuotą pagal skyriaus pavadinimą abėcėlės tvarka.
SELECT DEPTNO, DNAME
FROM DEPT
ORDER BY DNAME ASC;

-- 5. Parodykite visas skirtingas pareigas. Surūšiuokite jas atbuline abėcėlei tvarka.
SELECT DISTINCT JOB
FROM EMP
ORDER BY JOB DESC;

-- 6. Pateikite 10-o ir 30-o skyrių darbuotojų sąrašą, surūšiuotą pagal darbuotojo pavardę abėcėlės tvarka 
--    (darbuotojo numeris, pavardė, pareigos, viršininko numeris, priėmimo į darbą data, atlyginimas, komisiniai, skyriaus numeris).
SELECT EMPNO, ENAME AS SURNAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
FROM EMP
WHERE DEPTNO IN (10, 30)   -- ARBA DEPTNO=10 OR DEPTNO=30
ORDER BY ENAME;

-- 7. Pateikite visų pardavėjų (Salesman), kurių mėnesinis atlyginimas yra didesnis už komisinius,
--    pavardę, metinį atlyginimą ir komisinius. Išveskite šią informaciją į ekraną, 
--    rūšiuodami pagal atlyginimo dydį, pradėdami nuo didžiausio.
SELECT ENAME AS SURNAME, (SAL * 12) AS ANNUAL_SALARAY, COMM
FROM EMP
WHERE JOB = 'SALESMAN'
  AND SAL > NVL(COMM, 0)
ORDER BY (SAL * 12) DESC;

-- 8. Pateikite duomenis tokia tvarka: 
--    SMITH has held the position of CLERK in department 20 since 13-JUN-83
SELECT ENAME || ' has held the position of ' || JOB 
       || ' in department ' || DEPTNO 
       || ' since ' || TO_CHAR(HIREDATE, 'DD-MON-RR', 'NLS_DATE_LANGUAGE=ENGLISH') AS SENTENCE
FROM EMP
ORDER BY ENAME;

-- 9. Pateikite tarnautojų (CLERK), dirbančių 20-ame skyriuje, pavardes ir pareigas.
SELECT ENAME AS SURNAME, JOB
FROM EMP
WHERE JOB = 'CLERK' 
  AND DEPTNO = 20
ORDER BY ENAME;

-- 10. Pateikite darbuotojų pavardes, kuriose yra raidės TH arba LL.
SELECT ENAME AS SURNAME
FROM EMP
WHERE UPPER(ENAME) LIKE '%TH%' 
   OR UPPER(ENAME) LIKE '%LL%'
ORDER BY ENAME;

-- 11. Pateikite informaciją apie darbuotojus (pavardė, pareigos, viršininko numeris, atlyginimas), 
--     kurie turi vadovą.
SELECT ENAME AS SURNAME, JOB, MGR AS MANAGER_NO, SAL
FROM EMP
WHERE MGR IS NOT NULL
ORDER BY ENAME;

-- 12. Pateikite darbuotojų pavardes ir jų metines pajamas.
SELECT ENAME AS SURNAME, (SAL * 12 + NVL(COMM, 0)) AS ANNUAL_SALARY
FROM EMP
ORDER BY ENAME;

-- 13. Pateikite darbuotojų, priimtų į darbą 1983 metais, sąrašą 
--     (pavardė, skyriaus numeris, priėmimo į darbą data).
SELECT HIREDATE, ENAME AS SURNAME, DEPTNO
FROM EMP
WHERE HIREDATE BETWEEN DATE '1983-01-01' AND DATE '1983-12-31';


-- ____________________________________________________________________--


-- 2 LABORATORINIS
-- Kintamųjų nurodymas vykdymo metu

-- 1) Užklausa apie darbuotojus dirbančius nurodytose pareigose.
--    Naudojame kintamąjį &JOB_TITLE
SELECT ENAME AS SURNAME, JOB, SAL, DEPTNO
FROM EMP
WHERE JOB = '&JOB_TITLE';

-- Patikrinimui:
--   Kai užklausa paklaus, įrašykite CLERK, paskui SALESMAN, MANAGER ir pan.


-- 2) Apibrėžkite kintamąjį metiniam atlyginimui.
--    Pavyzdžiui, &ANNUAL_SAL reikšmė bus 30000.
SELECT ENAME AS SURNAME,
       (SAL * 12 + NVL(COMM, 0)) AS ANNUAL_SALARY
FROM EMP
WHERE (SAL * 12 + NVL(COMM, 0)) >= &ANNUAL_SAL;

-- Kai vykdysite, įveskite 30000, tada dar kartą paleiskite su 40000 ar pan.


-- 3) Darbuotojai, priimti į darbą tam tikrame intervale tarp dviejų datų.
--    Naudojame du kintamuosius &DATE_FROM ir &DATE_TO
SELECT ENAME AS SURNAME, HIREDATE, DEPTNO
FROM EMP
WHERE HIREDATE BETWEEN TO_DATE('&DATE_FROM', 'YYYY-MM-DD')
                  AND TO_DATE('&DATE_TO',   'YYYY-MM-DD');

-- Patikrinimui:
--   Kai paklaus, įveskite pvz. 1981-01-01 ir 1981-12-31
--   Vėliau pakartokite su 1982-01-01 ir 1983-12-31

-- 3b) Versija su dvigubu ampersandu (&&), kad išsaugotų reikšmę.
--     Įvedus vieną kartą, ta pati reikšmė naudosis vėl, be papildomo klausimo.
SELECT ENAME AS SURNAME, HIREDATE, DEPTNO
FROM EMP
WHERE HIREDATE BETWEEN TO_DATE('&&DATE_FROM', 'YYYY-MM-DD')
                  AND TO_DATE('&&DATE_TO',   'YYYY-MM-DD');


-- 4) ACCEPT komanda su visais galimais parametrais.
--    Ji leidžia vartotojui įvesti kintamąjį su gražesne žinute.
ACCEPT p_job     CHAR   PROMPT 'Įveskite pareigas: '
ACCEPT p_salary  NUMBER PROMPT 'Įveskite minimalų metinį atlyginimą: '
ACCEPT p_date1   DATE   FORMAT 'YYYY-MM-DD' PROMPT 'Įveskite intervalo pradžios datą (YYYY-MM-DD): '
ACCEPT p_date2   DATE   FORMAT 'YYYY-MM-DD' PROMPT 'Įveskite intervalo pabaigos datą (YYYY-MM-DD): '

-- Naudojame ACCEPT sukurtus kintamuosius
SELECT ENAME, JOB, (SAL*12) AS ANNUAL_SAL, HIREDATE
FROM EMP
WHERE JOB = '&p_job'
  AND (SAL*12) >= &p_salary
  AND HIREDATE BETWEEN TO_DATE('&p_date1','YYYY-MM-DD') 
                  AND TO_DATE('&p_date2','YYYY-MM-DD');


-- 5) Panaikinti visus sukurtus kintamuosius sesijoje
UNDEFINE JOB_TITLE
UNDEFINE ANNUAL_SAL
UNDEFINE DATE_FROM
UNDEFINE DATE_TO
UNDEFINE p_job  
UNDEFINE p_salary
UNDEFINE p_date1
UNDEFINE p_date2




-- ____________________________________________________________________--

--3 LABORATORINIS
  -- Vieno įrašo (single-row) funkcijos

/* 1. Pavardės ir algos padidintos 15% (sveiki skaičiai).
   ROUND(x) apvalina iki artimiausio sveiko. */
SELECT ENAME AS SURNAME,
       SAL AS CURRENT_SALARY,
       ROUND(SAL * 1.15) AS SALARY_PLUS_15
FROM EMP
ORDER BY ENAME;

/* 2. Formatas "EMPLOYEE_AND_JOB" -> "SMITH CLERK" ir t. t.
   Sujungiame stulpelius operatoriumi ||. */
SELECT ENAME || ' ' || UPPER(JOB) AS EMPLOYEE_AND_JOB
FROM EMP
ORDER BY ENAME;

/* 3. Pavardės, priėmimo data ir "REVIEW" data po 12 mėn.
   ADD_MONTHS(HIREDATE,12) patogiai prideda metus. */
SELECT ENAME AS SURNAME,
       HIREDATE,
       ADD_MONTHS(HIREDATE, 12) AS REVIEW_DATE
FROM EMP
ORDER BY REVIEW_DATE;

/* 4. Kiek laiko dirba įmonėje (metai ir mėnesiai).
   MONTHS_BETWEEN grąžina mėnesius (su trupmena).
   Imame tik sveiką dalį ir suskaidome į metus + likusius mėnesius. */
SELECT ENAME AS SURNAME,
       TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12) || ' YEARS ' ||
       MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)), 12) || ' MONTHS' AS "LENGTH OF SERVICE"
FROM EMP
ORDER BY ENAME;

/* 5. Pirmo atlygio diena pagal taisyklę:
      - jei priimtas iki 15 d. (imtinai) -> paskutinis to mėnesio penktadienis
      - kitaip -> kito mėnesio paskutinis penktadienis
   LAST_DAY(r) – paskutinė mėnesio diena,
   NEXT_DAY(d, 'FRIDAY') – kita penktadienio diena po d.
   Triukas: (LAST_DAY(...) - 7) atsiduriame paskutinėje mėnesio savaitėje,
           tuomet NEXT_DAY duoda "paskutinį penktadienį". */
SELECT ENAME AS SURNAME,
       HIREDATE,
       CASE
         WHEN TO_NUMBER(TO_CHAR(HIREDATE, 'DD')) <= 15
           THEN NEXT_DAY(LAST_DAY(HIREDATE) - 7, 'FRIDAY')
         ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS(HIREDATE, 1)) - 7, 'FRIDAY')
       END AS FIRST_PAYDAY
FROM EMP
ORDER BY HIREDATE;

/* 6. Formatas:
      EMPLOYEE
      ----------
      SMITH(Clerk)
      ALLEN(Salesman)
   INITCAP -> pirmoji raidė didžioji. */
SELECT ENAME || '(' || INITCAP(JOB) || ')' AS EMPLOYEE
FROM EMP
ORDER BY ENAME;

/* 7. Užklausa nepriklausoma nuo įvestų raidžių dydžio.
   Naudojame UPPER abiejose pusėse. */
ACCEPT v_job CHAR PROMPT 'Enter value for job: '
SELECT ENAME AS SURNAME, JOB, DEPTNO, SAL
FROM EMP
WHERE UPPER(JOB) = UPPER('&v_job');

/* 8. 30-ame skyriuje pakeičiame SALESMAN -> Salesperson (tik išvestyje). */
SELECT ENAME,
       DEPTNO,
       CASE
         WHEN DEPTNO = 30 AND UPPER(JOB) = 'SALESMAN' THEN 'Salesperson'
         ELSE INITCAP(JOB)
       END AS JOB
FROM EMP
WHERE DEPTNO = 30
ORDER BY ENAME;


-- ____________________________________________________________________--
  -- 4 LABORATORINIS
  -- Tipų konvertavimas ir NLS-nepriklausomos funkcijos

/* 1. 20-o skyriaus pavardės ir priėmimo datos.
   Stulpelis pavadintas DATE_HIRED; formatą darome kompaktišką, kad tilptų į vieną eilutę.
   FM slopina papildomus tarpus, 'NLS_DATE_LANGUAGE=ENGLISH' fiksuoja mėnesio kalbą. */
SELECT ENAME,
       TO_CHAR(HIREDATE, 'FMMonth, DD "d." YYYY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DATE_HIRED
FROM EMP
WHERE DEPTNO = 20
ORDER BY ENAME;

/* 2. Kiekvienam darbuotojui:
      - "Below 1500" jei SAL<1500
      - "On Target" jei SAL=1500
      - kitu atveju pati atlyginimo reikšmė (kaip tekstas).
   CASE leidžia tvarkingai suaprašyti sąlygas viename stulpelyje. */
SELECT ENAME,
       SAL,
       CASE
         WHEN SAL < 1500 THEN 'Below 1500'
         WHEN SAL = 1500 THEN 'On Target'
         ELSE TO_CHAR(SAL)
       END AS SALARY_FLAG
FROM EMP
ORDER BY ENAME;

/* 3. Įveskite datą formatu DD.MM.YYYY ir gaukite savaitės dieną.
   TO_DATE -> data iš teksto; TO_CHAR su 'DAY' -> dienos pavadinimas. */
ACCEPT anydate CHAR PROMPT 'Enter value for anydate (DD.MM.YYYY): '
SELECT TO_CHAR(TO_DATE('&anydate', 'DD.MM.YYYY'),
               'DAY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DAY
FROM DUAL;
-- Pavyzdys: įvedus 15.02.1996 gausite THURSDAY.



-- ____________________________________________________________________--




/* ============================================================
   SQL funkcijos su pvz
   ============================================================ */
   
//  || - NAUDOJAMA SUJUNGTI I VIENA COLUMN'A, PVZ: 
//  SELECT ENAME || ' - ' || LOWER(JOB) AS SENTENCE
//FROM EMP;         - PADARO, KAD BUTU VIENAM STULPELY ENAME - JOB, O NE TREJUOSE


/* -------------------------------------
   1) TO_DATE(tekstas, formatas)
   Paverčia tekstą į DATĄ pagal nurodytą formatą.
   Naudinga kai lygini, filtruji ar skaičiuoji su datomis.
   ------------------------------------- */

-- Pvz.1: paimam visus darbuotojus, priimtus po 1982-01-01
SELECT ENAME, HIREDATE
FROM EMP
WHERE HIREDATE > TO_DATE('1982-01-01', 'YYYY-MM-DD');

-- Pvz.2: filtruojam pagal įvestą datą tekstu (DD.MM.YYYY)
SELECT ENAME, HIREDATE
FROM EMP
WHERE HIREDATE = TO_DATE('15.02.1996', 'DD.MM.YYYY');


/* -------------------------------------
   2) NVL(stulpelis, reikšmė)
   Jei stulpelis yra NULL → pakeičia į reikšmę.
   Labai naudinga su skaičiais (pvz. komisiniai).
   ------------------------------------- */

-- Pvz.1: paskaičiuojam metinę algą + komisinius (jei nėra, laikom 0)
SELECT ENAME, (SAL*12 + NVL(COMM,0)) AS ANNUAL_INCOME
FROM EMP;

-- Pvz.2: rodome komisinius, jei nėra → rašom 'NO BONUS'
SELECT ENAME, NVL(TO_CHAR(COMM), 'NO BONUS') AS COMM_INFO
FROM EMP;


/* -------------------------------------
   3) TO_CHAR(reikšmė, formatas)
   Paverčia DATĄ arba SKAIČIŲ į tekstą pagal formatą.
   Naudinga, kai reikia rodyti datas gražiai arba sujungti į tekstą.
   ------------------------------------- */

-- Pvz.1: parodyk datą DD.MM.YYYY formatu
SELECT ENAME, TO_CHAR(HIREDATE, 'DD.MM.YYYY') AS FORMATTED_DATE
FROM EMP;

-- Pvz.2: parodyk algą su valiutos simboliu
SELECT ENAME, TO_CHAR(SAL, '9999.99') || ' EUR' AS SALARY_EUR
FROM EMP;


/* -------------------------------------
   4) TO_NUMBER(tekstas, formatas)
   Paverčia tekstą į SKAIČIŲ.
   Dažnai naudojama kai tekstas yra skaičius.
   ------------------------------------- */

-- Pvz.1: pridedam prie skaičiaus tekstą (konvertuojam į skaičių)
SELECT TO_NUMBER('1500') + 200 AS RESULT
FROM DUAL;

-- Pvz.2: tekstą '01-01-1983' → data → paskui paimam metus kaip skaičių
SELECT TO_NUMBER(TO_CHAR(TO_DATE('01-01-1983','DD-MM-YYYY'),'YYYY')) AS YEAR_NUM
FROM DUAL;


/* -------------------------------------
   5) ACCEPT
   Leidžia naudotojui įvesti reikšmę prieš paleidžiant užklausą.
   Dirba tik SQL*Plus ar SQLcl (ne veikia GUI įrankiuose).
   ------------------------------------- */

-- Pvz.1: įvedam minimalią algą
ACCEPT min_sal NUMBER PROMPT 'Įveskite minimalią algą: '
SELECT ENAME, SAL
FROM EMP
WHERE SAL >= &min_sal;

-- Pvz.2: įvedam datą
ACCEPT p_date DATE FORMAT 'YYYY-MM-DD' PROMPT 'Įveskite datą (YYYY-MM-DD): '
SELECT ENAME, HIREDATE
FROM EMP
WHERE HIREDATE >= TO_DATE('&p_date','YYYY-MM-DD');


/* ============================================================
   TRUMPAS REZIUME
   TO_DATE()   – tekstą → data
   NVL()       – jei NULL → pakeičia
   TO_CHAR()   – skaičių/datą → tekstas (formatuotas)
   TO_NUMBER() – tekstą → skaičius
   ACCEPT      – leidžia vartotojui įvesti reikšmę prieš query
   ============================================================ */






-- ____________________________________________________________________--


-- 5 LABORATORINIS
-- Grupinės funkcijos

-- 1. Suraskite mažiausią darbuotojų atlyginimą.
SELECT MIN(SAL) AS MIN_SALARY
FROM EMP;

-- 2. Suraskite darbuotojų didžiausią, mažiausią ir vidutinį atlyginimus.
SELECT MAX(SAL) AS MAX_SALARY,
       MIN(SAL) AS MIN_SALARY,
       AVG(SAL) AS AVG_SALARY
FROM EMP;

-- 3. Pateikite mažiausią ir didžiausią atlyginimus kiekvienoms pareigoms.
SELECT JOB,
       MIN(SAL) AS MIN_SALARY,
       MAX(SAL) AS MAX_SALARY
FROM EMP
GROUP BY JOB;

-- 4. Suraskite, kiek yra vadybininkų, neišvardinant jų.
SELECT COUNT(*) AS MANAGER_COUNT
FROM EMP
WHERE JOB = 'MANAGER';

-- 5. Paskaičiuokite atlyginimų vidurkį ir visų pajamų vidurkį kiekvienoms pareigoms.
--    (Pajamos = atlyginimas + komisiniai, jei yra)
SELECT JOB,
       AVG(SAL) AS AVG_SALARY,
       AVG(SAL + NVL(COMM, 0)) AS AVG_TOTAL_INCOME
FROM EMP
GROUP BY JOB;

-- 6. Suraskite skirtumą tarp didžiausio ir mažiausio darbo užmokesčio.
SELECT (MAX(SAL) - MIN(SAL)) AS SALARY_DIFFERENCE
FROM EMP;

-- 7. Suraskite visus skyrius, kuriuose dirba daugiau kaip 3 darbuotojai.
SELECT DEPTNO,
       COUNT(*) AS EMP_COUNT
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(*) > 3;

-- 8. Patikrinkite, ar darbuotojų numeriai iš tikrųjų nepasikartoja.
SELECT EMPNO,
       COUNT(*) AS OCCURRENCES
FROM EMP
GROUP BY EMPNO
HAVING COUNT(*) > 1;

-- 9. Pateikite kiekvieno vadovo mažiausiai apmokamo darbuotojo atlyginimą.
--    Neįtraukite tų grupių, kur atlyginimas < 1000.
--    Informaciją pateikite atlyginimų didėjimo tvarka.
SELECT MGR AS MANAGER_NO,
       MIN(SAL) AS MIN_SALARY
FROM EMP
WHERE MGR IS NOT NULL
GROUP BY MGR
HAVING MIN(SAL) >= 1000
ORDER BY MIN(SAL);

-- 10. Suraskite bendrą atlyginimą, kurį uždirba vadybininkai.
SELECT SUM(SAL) AS TOTAL_MANAGER_SALARY
FROM EMP
WHERE JOB = 'MANAGER';

-- 11. Išveskite kiek žmonių kokiose pareigose dirba kiekviename skyriuje.
SELECT DEPTNO,
       JOB,
       COUNT(*) AS EMP_COUNT
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;


-- ____________________________________________________________________--

/* ============================================================
   WHERE vs ORDER BY
   ============================================================ */

/*
WHERE  – filtruoja EILUTES pagal sąlygą (kas pateks į rezultatą).
ORDER BY – surikiuoja jau atrinktas eilutes (kokia tvarka pateikti).
*/


/* ----------------------
   WHERE pavyzdžiai
   ---------------------- */

-- Pvz.1: darbuotojai su alga > 2000
SELECT ENAME, SAL
FROM EMP
WHERE SAL > 2000;

-- Pvz.2: tik iš 10-o skyriaus
SELECT ENAME, DEPTNO
FROM EMP
WHERE DEPTNO = 10;


/* ----------------------
   ORDER BY pavyzdžiai
   ---------------------- */

-- Pvz.1: surikiuoti darbuotojus pagal algą nuo didžiausios iki mažiausios
SELECT ENAME, SAL
FROM EMP
ORDER BY SAL DESC;

-- Pvz.2: surikiuoti pagal skyrių, o skyriuje – pagal pavardę
SELECT ENAME, DEPTNO
FROM EMP
ORDER BY DEPTNO, ENAME;

/* ============================================================
   Pavyzdžiai, kur kartu naudojami WHERE + ORDER BY
   ============================================================ */

/* Pvz.1:
   Rodyti darbuotojus, kurie uždirba daugiau nei 1500,
   bet surikiuoti juos pagal algą mažėjančia tvarka.
   (WHERE atrenka tik tinkamus, ORDER BY padaro tvarką.) */
SELECT ENAME, SAL
FROM EMP
WHERE SAL > 1500
ORDER BY SAL DESC;


/* Pvz.2:
   Rodyti tik 30-o skyriaus darbuotojus,
   surikiuotus pagal priėmimo datą (nuo seniausio iki naujausio).
   (WHERE atrenka skyrių, ORDER BY rūšiuoja datas.) */
SELECT ENAME, DEPTNO, HIREDATE
FROM EMP
WHERE DEPTNO = 30
ORDER BY HIREDATE ASC;


-- ____________________________________________________________________--



/* ============================================================

PRAKTINIS TESTAS
you in
   ============================================================ */


/* =========================
   A. Baziniai atrinkimai
   ========================= */

/* A1) Išvesk visus darbuotojus, kurių pavardė prasideda raide 'M'
       ARBA baigiasi raide 'N'. (EMP.ENAME) */
-- Write your query below:
select ENAME
from EMP
where upper(ENAME) like 'M%' OR upper(ENAME) like '%N';



/* A2) Pateik visus skyrius, kuriuose nėra nė vieno darbuotojo.
       Naudok LEFT JOIN arba sub-užklausą (DEPT vs EMP). */
-- Write your query below:
SELECT DEPTNO, DNAME
FROM DEPT
WHERE NOT EXISTS (
    SELECT 1
    FROM EMP
    WHERE EMP.DEPTNO = DEPT.DEPTNO
);

--      CHAT GPT BUDAS      --
SELECT DEPTNO, DNAME, LOC
FROM DEPT
WHERE NOT EXISTS (
    SELECT 1
    FROM EMP
    WHERE EMP.DEPTNO = DEPT.DEPTNO
);


/* A3) Rask darbuotojus, kurių komisiniai yra:
       - NULL
       - lygūs 0
       Parodyk dvi atskiras kolonas su TRUE/FALSE žyma
       (pvz., HAS_NULL_COMM, HAS_ZERO_COMM). */
-- Write your query below:
select ename,
    CASE
        when comm is null then 'TRUE'
        else 'FALSE'
    END AS HAS_NULL_COMM,
    CASE
        WHEN COMM = 0 THEN 'TRUE'
        ELSE 'FALSE'
        END AS HAS_ZERO_COMM
FROM EMP;


/* ===========================================
   B. Vieno įrašo funkcijos / formatavimas
   =========================================== */

/* B4) Išvesk ENAME ir JOB taip: "SMITH - clerk"
       (pareigos mažosiomis raidėmis). */
-- Write your query below:
-- V SITAS NETEISINGAS, NES PADARO 3 STULPELIUS V --
SELECT ENAME, ' - ', JOB AS SENTENCE
FROM EMP;

-- V SITAS TEISINGAS, NES SUJUNGIA 3 STULPELIUS I 1 V --
SELECT ENAME || ' - ' || LOWER(JOB) AS SENTENCE
FROM EMP;


/* B5) Parodyk ENAME, HIREDATE ir dienų skaičių,
       kiek žmogus jau išdirbo iki šiandien (SYSDATE). */
-- Write your query below:
SELECT ENAME, HIREDATE, TRUNC(SYSDATE - HIREDATE) AS DAYS_WORKED
FROM EMP;

/* B6) Sukurk stulpelį EMAIL formatu:
       lower(ename) || '@company.com' */
-- Write your query below:


/* B7) Parodyk ENAME ir tekstą:
       "NEW"  – jei priimtas per paskutinius 6 mėnesius,
       "EXPERIENCED" – kitu atveju. */
-- Write your query below:



/* =================
   C. Datų logika
   ================= */

/* C8) Pateik ENAME, HIREDATE ir paskutinės atostogų dienos datą,
       jei atostogos prasideda lygiai po 2 metų darbo ir trunka
       14 kalendorinių dienų. (ADD_MONTHS, +14, ir pan.) */
-- Write your query below:


/* C9) Interaktyviai įvesk duomenis (dvi datos) ir parodyk darbuotojus,
       kurių REVIEW data (HIREDATE + 12 mėn.) patenka į intervalą.
       Patogu naudoti &DATE_FROM ir &DATE_TO arba ACCEPT. */
-- Example (you will write the SELECT):
-- ACCEPT DATE_FROM CHAR PROMPT 'Enter start (YYYY-MM-DD): '
-- ACCEPT DATE_TO   CHAR PROMPT 'Enter end   (YYYY-MM-DD): '
-- Write your query below:


/* C10) Parodyk, kurią savaitės dieną žmogus buvo priimtas
        (pvz., MONDAY) ir ar tai buvo darbo diena (Mon–Fri)
        ar savaitgalis. */
-- Write your query below:



/* =====================
   D. Grupinės funkcijos
   ===================== */

/* D11) Kiekvienam skyriui parodyk:
        - darbuotojų skaičių,
        - vidutinę algą,
        - didžiausią algą;
        rikiuok pagal vidutinę algą mažėjančiai. */
-- Write your query below:


/* D12) Rask pareigą (-as), kurioje vidutinė alga didžiausia.
        Jei yra lygybių – grąžink visas. */
-- Write your query below:


/* D13) Kiekvienam vadovui parodyk pavaldinių skaičių.
        Įtrauk ir vadovus, kurie šiuo metu neturi pavaldinių (0). */
-- Write your query below:



/* ===========================
   E. CASE, NVL, DECODE
   =========================== */

/* E14) Sukurk BONUS_FLAG stulpelį:
        'HAS BONUS'  jei COMM > 0
        'NO BONUS'   jei COMM = 0
        'UNKNOWN'    jei COMM IS NULL */
-- Write your query below:


/* E15) Pateik ENAME ir SAL_LEVEL pagal SALGRADE diapazonus.
        Galutinį lygį parodyk kaip A, B, C, ... (arba 1,2,3,...).
        (Join EMP.SAL su SALGRADE.LO SAL–HI). */
-- Write your query below:


/* E16) Vietoje 'SALESMAN' rodyk 'Salesperson' (visuose skyriuose),
        kitur – INITCAP(JOB). Tik išvestyje, neredaguojant duomenų. */
-- Write your query below:



/* ===============================
   F. Join’ai ir sub-užklausos
   =============================== */

/* F17) Parodyk ENAME, DNAME ir LOC (join su DEPT),
        rikiuok pagal LOC. */
-- Write your query below:


/* F18) Pateik darbuotojus, kurių alga yra aukštesnė už
        SAVO skyriaus vidurkį. */
-- Write your query below:


/* F19) Pateik skyrius, kuriuose nėra pareigybės 'CLERK'.
        (NOT EXISTS yra patogu.) */
-- Write your query below:


/* F20) Pateik darbuotojų sąrašą su jų vadovų pavardėmis
        toje pačioje eilutėje (self-join EMP->EMP). */
-- Write your query below:



/* ===========================
   G. Interaktyvūs kintamieji
   =========================== */

/* G21) Įvesk minimalų ir maksimalų atlyginimą ir parodyk
        atitinkamus darbuotojus (BETWEEN).
        Pvz.: &MIN_SAL ir &MAX_SAL arba ACCEPT. */
-- Write your query below:


/* G22) Įvesk pareigą (case-insensitive) ir skyrių; parodyk tik tuos
        darbuotojus, kurie atitinka abu kriterijus. */
-- Write your query below:


/* G23) Įvesk datą DD.MM.YYYY ir parodyk, kiek dienų liko
        iki tos datos nuo šiandien. */
-- Write your query below:



/* ==================
   H. Smulkūs triukai
   ================== */

/* H24) Parodyk ENAME ir PAYDAY – artimiausią (nuo šiandien)
        penktadienį. (NEXT_DAY) */
-- Write your query below:


/* H25) Parodyk ENAME ir sutrumpintą pavardę kaip S**H
        (pirmoji ir paskutinė raidės, vidurys žvaigždutėmis). */
-- Write your query below:


/* H26) Išvesk kiekvieno skyriaus antrą pagal dydį algą (jei yra).
        (Analitinės funkcijos arba sub-užklausos.) */
-- Write your query below:


/* ============================
   END OF TASKS — good luck!
   ============================ */
   
   
/*
    kai selectini is stulpelio(pirma eil) galima naudot tik case, when, else, end as,..
    virsuj negalima naudot WHERE
    
*/


