CREATE TABLE TABLE_NOTNULL
(ID CHAR(3) NOT NULL, SNAME VARCHAR2(20));
INSERT INTO TABLE_NOTNULL
VALUES ('100', 'ORACLE');


--INSERT--
INSERT INTO 테이블_이름 VALUES([VALUE],);
INSERT INTO 테이블_이름([COLUMN_NAME]) VALUES([VALUE],DAFUALT);

----

CREATE TABLE TABLE_UNIQUE2
(ID		CHAR(3),
 SNAME	VARCHAR2(20),
 SCODE	CHAR(2),
 CONSTRAINT TN2_ID_UN	UNIQUE(ID,SNAME));
 

--두개의 외래키가 한 테이블의 기본키가 될 수 있음. (복합키로)--

 CREATE TABLE TABLE_PK2
 (ID	CHAR(3),
  SNAME	VARCHAR2(20),
  SCODE	CHAR(2),
  CONSTRAINT TP2_PK PRIMARY KEY (ID,SNAME));
  
 
 --외래키--
 CREATE TABLE TABLE_FK
 (ID	CHAR(3),
  SNAME	VARCHAR2(20),
  LID	CHAR(2) REFRENCES(LOCATION(LOCATION_ID)));
  
 --특정 값을 CHECK하는 제약조건--
 CREATE TABLE TABLE_CHECK
 (EMP_ID	CHAR(3)	PRIMARY KEY,
  SALARY	NUMBER	CHECK (SALARY>0),
  MARRIAGE CHAR(1),
  CONSTRAINT CHK_MRG CHECK (MARRIAGE IN ('Y','N')) );


CREATE TABLE TABLE_SUBQUERY1
AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_NAME, JOB_TITLE
 	FROM EMPLOYEE
 	LEFT JOIN DEPARTMENT USING (DEPT_ID)
 	LEFT JOIN JOB USING(JOB_ID);

 	
--이렇게 넘겨오면 NOT NULL만 넘어오기때문에 다른 제약조건을 새로 추가해줘야한다--
--HIRE_DATE는 원래 낫널 조건이 없는 칼럼이었는데 이번 테이블에서 새로 추가해주고싶다면 ADD가 아니라 MODIFY로 해줘야한다--
CREATE TABLE EMP3 AS SELECT * FROM EMPLOYEE;
ALTER TABLE EMP3
ADD PRIMARY KEY(EMP_ID)
ADD UNIQUE (EMP_NO)
MODIFY HIRE_DATE NOT NULL;


--뷰--
CREATE OR REPLACE VIEW V_EMP_DEPT_JOB (ENM,DNM,TITLE)
AS SELECT EMP_NAME, DEPT_NAME, JOB_TITLE
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT USING (DEPT_ID)
	LEFT JOIN JOB USING (JOB_ID)
	WHERE	JOB_TITLE ='사원';
--위 쿼리랑 같은것이다.--
CREATE OR REPLACE VIEW V_EMP_DEPT_JOB
AS SELECT EMP_NAME AS ENM,
			  DEPT_NAME AS DNM,
			  JOB_TITLE AS TITLE
	   FROM EMPLOYEE
	   LEFT JOIN DEPARTMENT USING(DEPT_ID)
	   LEFT JOIN JOB USING(JOB_ID)
	   WHERE	JOB_TITLE ='사원';
	   
	   
SELECT * FROM V_EMP_DEPT_JOB;

--뷰를 먼저 만들고 셀렉트절하는것--
CREATE OR REPLACE VIEW V_DEPT_SALAVG ("Did","Davg")
AS SELECT NVL(DEPT_ID, 'N/A'),
		  ROUND(AVG(SALARY),-3)
FROM	EMPLOYEE
GROUP BY DEPT_ID;

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
JOIN V_DEPT_SALAVG ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY > "Davg"
ORDER BY 2 DESC;

--뷰와 셀렉트를 한번에--
SELECT EMP_NAME, SALARY
FROM (SELECT NVL(DEPT_ID, 'N/A') AS "Did",
		  ROUND(AVG(SALARY),-3) AS "Davg"
FROM	EMPLOYEE
GROUP BY DEPT_ID) INLV
JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY>INLV."Davg";

--TOP N 분석--
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT NVL(DEPT_ID, 'N/A') AS "Did",
		  ROUND(AVG(SALARY),-3) AS "Davg"
FROM	EMPLOYEE
GROUP BY DEPT_ID) INLV
JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY>INLV."Davg";

--ORDER BY를 넣으면 흐트러진다--
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT NVL(DEPT_ID, 'N/A') AS "Did",
		  ROUND(AVG(SALARY),-3) AS "Davg"
FROM	EMPLOYEE
GROUP BY DEPT_ID) INLV
JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY>INLV."Davg"
ORDER BY 3 DESC;

--그래서 먼저!!!! 정렬을 한 뒤 ROWNUM을 부여해야한다--
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT NVL(DEPT_ID, 'N/A') AS "Did",
		  ROUND(AVG(SALARY),-3) AS "Davg"
FROM	EMPLOYEE
GROUP BY DEPT_ID) INLV
JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY>INLV."Davg"
AND ROWNUM = 1;
--범위 검색은 가능하다. 다섯번을 끊어올수는 있다 (정렬은 제대로 안됨)--
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT NVL(DEPT_ID, 'N/A') AS "Did",
		  ROUND(AVG(SALARY),-3) AS "Davg"
FROM	EMPLOYEE
GROUP BY DEPT_ID) INLV
JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
WHERE SALARY>INLV."Davg"
AND ROWNUM <= 5;
--그래서 인라인뷰 안에서 먼저 오더바이를 해야한다--
SELECT	ROWNUM, EMP_NAME, SALARY
	FROM	(SELECT EMP_NAME, SALARY
			 FROM	(SELECT NVL(DEPT_ID, 'N/A') AS "Did",
			  				ROUND(AVG(SALARY),-3) AS "Davg"
					 FROM	EMPLOYEE
					 GROUP BY DEPT_ID) INLV
					 JOIN EMPLOYEE ON (NVL(DEPT_ID, 'N/A') = INLV."Did")
					 WHERE SALARY>INLV."Davg"
					 ORDER BY 2 DESC
					)
WHERE ROWNUM <= 5;

--이거 다시--
SELECT	ROWNUM, EMP_NAME, JOB_TITLE, SALARY
FROM	(SELECT EMP_NAME, JOB_TITLE, SALARY
		 FROM	(SELECT NVL NVL(JOB_ID,'N/A')AS JID,
		 				SALARY AS SAL
		 		 FROM EMPLOYEE
		 		 JOIN JOB USING(JOB_ID)
		 		 ) INLV
		 	JOIN JOB ON (NVL(JOB_ID, 'N/A') = INLV.JID)
		 	WHERE SALARY > INLV.SAL
		 	ORDER BY 2 DESC		 
		 )
WHERE ROWNUM <=5;

--랭크함수--
SELECT *
FROM	(SELECT	EMP_NAME,
				SALARY,
				RANK() OVER (ORDER BY SALARY DESC) AS RANK
		 FROM EMPLOYEE)
WHERE RANK=2;

SELECT	RANK(2300000)WITHIN GROUP (ORDER BY SALARY DESC) AS RANK
FROM	EMPLOYEE;

SELECT	EMP_NAME, SALARY,
		RANK() OVER (ORDER BY SALARY DESC) AS RANK
FROM	EMPLOYEE;

--시퀀스 개념 및 생성구문--
CREATE SEQUENCE SEQ3_EMPID
INCREMENT BY 5
START WITH	300 MAXVALUE 310
NOCYCLE NOCACHE;

--시퀀스 삭제는 DROP (객체 삭제이므로)--

--DML에서도 다 서브쿼리를 쓸 수 있다--


----------------------------------------------------------------
-------------------------WORKBOOK------------------------------


CREATE TABLE CUSTOMERS(
CNO		NUMBER(5) PRIMARY KEY,
CNAME	VARCHAR2(10) NOT NULL,
ADDRESS	VARCHAR2(50) NOT NULL,
EMAIL	VARCHAR2(20) NOT NULL,
PHONE	VARCHAR2(20) NOT NULL
);
CREATE TABLE ORDERS (
ORDERNO		NUMBER(10)	PRIMARY KEY,
ORDERDATE	DATE	DEFAULT	SYSDATE,
ADDRESS	VARCHAR2(50)	NOT NULL,
PHONE	VARCHAR2(20)	NOT NULL,
STATUS	VARCHAR2(20)	NOT NULL,
CNO		NUMBER(5) REFERENCES CUSTOMERS(CNO),
CONSTRAINT CHK_STATUS CHECK (STATUS IN ('결제완료','배송중','배송완료'))
);
CREATE TABLE PRODUCTS(
PNO		NUMBER(5)	PRIMARY KEY,
PNAME	VARCHAR2(20)	NOT NULL,
COST	NUMBER(8)	DEFAULT 0	NOT NULL,
STOCK	NUMBER(5)	DEFAULT 0	NOT NULL	
);

CREATE TABLE ORDERDETAIL(
ORDERNO	NUMBER(10)	REFERENCES ORDERS(ORDERNO),
PNO		NUMBER(5)	REFERENCES PRODUCTS(PNO),
QTY		NUMBER(5)	DEFAULT 0,
COST	NUMBER(8)	DEFAULT 0,
CONSTRAINT OP_PK1 PRIMARY KEY (ORDERNO,PNO)
);

INSERT INTO PRODUCTS
VALUES (1001, '삼양라면',1000,200 );
INSERT INTO PRODUCTS
VALUES (1002, '새우깡', 1500, 500 );
INSERT INTO PRODUCTS
VALUES (1003, '월드콘', 2000, 350 );
INSERT INTO PRODUCTS
VALUES (1004, '빼뺴로', 2000, 700 );
INSERT INTO PRODUCTS
VALUES (1005, '코카콜라', 1800, 550 );
INSERT INTO PRODUCTS
VALUES (1006, '환타', 1600, 300 );

INSERT INTO CUSTOMERS
VALUES (101, '김철수', '서울 강남구', 'cskim@naver.com', '899-6666');
INSERT INTO CUSTOMERS
VALUES (102, '이영희', '부산 서면', 'yhlee@empal.com', '355-8882');
INSERT INTO CUSTOMERS
VALUES (103, '최진국', '제주 동광양', 'jkchoi@gmail.com', '852-5764' );
INSERT INTO CUSTOMERS
VALUES (104, '강준호', '강릉 홍제동', 'jhkang@hanmail.com', '559-7777' );
INSERT INTO CUSTOMERS
VALUES (105, '민병국', '대전 전민동', 'bgmin@hotmail.com', '559-8741' );
INSERT INTO CUSTOMERS
VALUES (106, '오민수', '광주 북구', 'msoh@microsoft.com', '542-9988' );

--4--
SELECT * FROM ORDERS;
SELECT * FROM ORDERDETAIL;
INSERT INTO ORDERS
VALUES (1, SYSDATE-3, '서울 강남구', '899-6666', '결제완료', 101);
INSERT INTO ORDERDETAIL
VALUES (1, 1001, 50, 1000);

--5--
UPDATE PRODUCTS
SET STOCK = STOCK-50
WHERE PNO=1001;
SELECT * FROM PRODUCTS;

--6--
INSERT INTO ORDERS
VALUES (2, SYSDATE-2, '부산 수영구', '337-5000', '결제완료', 102);
INSERT INTO ORDERDETAIL
VALUES (2, 1002, 100, 1500);
INSERT INTO ORDERDETAIL
VALUES (2, 1003, 150, 2000);

--7--

UPDATE PRODUCTS
SET STOCK = STOCK-100
WHERE PNO=1002;
UPDATE PRODUCTS
SET STOCK = STOCK-150
WHERE PNO=1003;
SELECT * FROM PRODUCTS;

--8--
INSERT INTO ORDERS
VALUES (3, SYSDATE-1, '광주 북구', '652-2277', '결제완료', 106);
INSERT INTO ORDERDETAIL
VALUES (3, 1004, 100, 2000);
INSERT INTO ORDERDETAIL
VALUES (3, 1005, 50, 1800);

--9--
UPDATE PRODUCTS
SET STOCK = STOCK-100
WHERE PNO=1004;
UPDATE PRODUCTS
SET STOCK = STOCK-50
WHERE PNO=1005;
SELECT * FROM PRODUCTS;

--10--
CREATE OR REPLACE VIEW V_PDCTS_CSTMRS_ORDRS_ORDTL
AS SELECT	O.ORDERDATE AS ORD,
			C.CNAME AS CN,
			C.ADDRESS AS ADDR,
			C.PHONE AS PHN,
			O.STATUS AS STS,
			P.PNAME AS PN,
			OD.COST AS CST,
			OD.QTY AS Q,
			OD.COST*OD.QTY AS CQT
	   FROM CUSTOMERS C
	   JOIN ORDERS O ON C.CNO=O.CNO
	   JOIN ORDERDETAIL OD ON O.ORDERNO=OD.ORDERNO
	   JOIN PRODUCTS P ON OD.PNO=P.PNO;

SELECT * FROM V_PDCTS_CSTMRS_ORDRS_ORDTL;


CREATE OR REPLACE VIEW V_DAILY_SALES
AS SELECT	O.ORDERDATE AS ORD,
			SUM(COST*QTY) AS DAILYSALES
	FROM	ORDERS O
	JOIN	ORDERDETAIL OD ON O.ORDERNO=OD.ORDERNO
	GROUP BY O.ORDERDATE
	ORDER BY ORD;
SELECT * FROM V_DAILY_SALES;

--12--
SELECT * FROM PRODUCTS;
INSERT INTO PRODUCTS
VALUES (1007, '목캔디', 3000, 500);

--13--
INSERT INTO ORDERS
VALUES (4, SYSDATE, '제주 동광양', '352-4657', '결제완료', 103);
INSERT INTO ORDERDETAIL
VALUES (4, 1007, 200, 3000);

UPDATE PRODUCTS
SET STOCK = STOCK-200
WHERE PNO=1007;

SELECT * FROM PRODUCTS;

--------------------------------------------------------
---------------------WORKBOOK2--------------------------
--------------------------------------------------------


--1--

CREATE TABLE MEMBER(
MEMBER_ID	NUMBER(10) PRIMARY KEY,
NAME	VARCHAR2(25) NOT NULL,
ADDRESS	VARCHAR2(100),
CITY	VARCHAR2(30),
PHONE	VARCHAR2(15),
JOIN_DATE DATE DEFAULT SYSDATE NOT NULL
);
CREATE TABLE TITLE (
TITLE_ID	NUMBER(10)	PRIMARY KEY,
TITLE		VARCHAR2(60)	NOT NULL,
DESCRIPTION	VARCHAR2(400)	NOT NULL,
RATING		VARCHAR2(20) 	CHECK(RATING IN('18가','15가','12가','전체가')) ,
CATEGORY	VARCHAR2(20)	CHECK(CATEGORY IN('드라마','코미디','액션','아동','SF','다큐멘터리') ) ,
RELEASE_DATE	DATE	DEFAULT	SYSDATE
);
CREATE TABLE TITLE_COPY(
COPY_ID		NUMBER(10),
TITLE_ID	NUMBER(10)		REFERENCES TITLE(TITLE_ID),
STATUS		VARCHAR2(20)	CHECK(STATUS IN('대여가능','파손','대여중','예약'))	NOT NULL,
CONSTRAINT TC_PK1 PRIMARY KEY (COPY_ID,TITLE_ID)
);

CREATE TABLE RENTAL(
BOOK_DATE	DATE	DEFAULT	SYSDATE,
MEMBER_ID	NUMBER(10)	,
COPY_ID		NUMBER(10)	,
TITLE_ID	NUMBER(10)	,
ACT_RET_DATE	DATE,
EXP_RET_DATE	DATE	DEFAULT SYSDATE+2,
CONSTRAINT RT_PK1 PRIMARY KEY (BOOK_DATE,MEMBER_ID,COPY_ID,TITLE_ID),
CONSTRAINT FK1	FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID),
CONSTRAINT FK2	FOREIGN KEY (COPY_ID,TITLE_ID) REFERENCES TITLE_COPY(COPY_ID,TITLE_ID)
);

CREATE TABLE RESERVATION(
RES_DATE	DATE,
MEMBER_ID	NUMBER(10)	REFERENCES MEMBER(MEMBER_ID),
TITLE_ID	NUMBER(10)	REFERENCES TITLE(TITLE_ID),
CONSTRAINT RS_PK1 PRIMARY KEY(RES_DATE,MEMBER_ID,TITLE_ID)
);

--2--
CREATE SEQUENCE MEMBER_ID_SEQ
INCREMENT BY 1 START WITH 101 NOMAXVALUE NOCYCLE NOCACHE;
CREATE SEQUENCE TITLE_ID_SEQ
INCREMENT BY 1 START WITH 92 NOMAXVALUE NOCYCLE NOCACHE;
DROP SEQUENCE MEMBER_ID_SEQ;
DROP SEQUENCE TITLE_ID_SEQ;

DROP TABLE RENTAL;
DROP TABLE TITLE_COPY;
DROP TABLE RESERVATION;
DROP TABLE TITLE;
DROP TABLE MEMBER;



INSERT INTO EMPLOYEE (EMP_ID, EMP_NO, EMP_NAME)
VALUES (TO_CHAR(SEQID.NEXTVAL), '850130-1558215', '김영민')

INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'인어공주', '인어공주 설명', '전체가', '아동', '95/10/05');
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'매트릭스', '매트릭스 설명', '15가', 'SF', '95/05/19' );
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'에이리언', '에이리언 설명', '18가', 'SF', '95/08/12');
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'모던타임즈', '모던타임즈 설명', '전체가', '코미디', '95/07/12' );
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'러브스토리', '러브스토리 설명', '전체가', '드라마', '95/09/12' );
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'람보', '람보 설명', '18가', '액션', '95/06/01' );


--4--
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'김철수', '강남구', '서울', '899-6666', '90/03/08' );
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'이영희', '서면', '부산', '355-8882', '90/03/08' );
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'최진국', '동광양', '제주', '852-5764', '91/06/17' );
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'강준호', '홍제동', '강릉', '559-7777', '90/04/07' );
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'민병국', '전민동', '대전', '559-8741', '91/01/18' );
INSERT INTO MEMBER
VALUES (MEMBER_ID_SEQ.NEXTVAL,'오민수', '북구', '광주', '542-9988', '91/01/18' );


SELECT * FROM TITLE_COPY;
SELECT * FROM TITLE;
--5--
COPY_ID, TITLEID STATUS
INSERT INTO TITLE_COPY
VALUES (1,92,'대여가능');
INSERT INTO TITLE_COPY
VALUES (1,93,'대여가능');
INSERT INTO TITLE_COPY
VALUES (2,93,'대여중');
INSERT INTO TITLE_COPY
VALUES (1,94,'대여가능');
INSERT INTO TITLE_COPY
VALUES (1,95,'대여가능');
INSERT INTO TITLE_COPY
VALUES (2,95,'대여가능');
INSERT INTO TITLE_COPY
VALUES (3,95,'대여중');
INSERT INTO TITLE_COPY
VALUES (1,96,'대여가능');
INSERT INTO TITLE_COPY
VALUES (1,97,'대여가능');

--6--
BOOK_DATE	DATE	DEFAULT	SYSDATE,
MEMBER_ID	NUMBER(10)	,
COPY_ID		NUMBER(10)	,
TITLE_ID	NUMBER(10)	,
ACT_RET_DATE	DATE,
EXP_RET_DATE	DATE	DEFAULT SYSDATE+2,
SELECT * FROM RENTAL
SELECT * FROM MEMBER;
1345
UPDATE RENTAL
SET ACT_RET_DATE = SYSDATE-2
WHERE MEMBER_ID=1;
--6--
INSERT INTO RENTAL
VALUES (SYSDATE-3,101,1,92,SYSDATE-2,SYSDATE-1);
INSERT INTO RENTAL
VALUES (SYSDATE-1,103,2,93,DEFAULT,SYSDATE+1);
INSERT INTO RENTAL
VALUES (SYSDATE-2,104,3,95,DEFAULT,SYSDATE);
INSERT INTO RENTAL
VALUES (SYSDATE-4,105,1,97,SYSDATE-2,SYSDATE-1);

--7--
CREATE OR REPLACE VIEW V_TITLE_AVAIL
AS SELECT	T.TITLE AS TITLE,
			TC.COPY_ID AS COPY_ID,
			TC.STATUS	AS STATUS,
			R.EXP_RET_DATE AS EXP_RET_DATE
	FROM	TITLE T
	FULL JOIN	TITLE_COPY TC ON T.TITLE_ID=TC.TITLE_ID
	FULL JOIN	RENTAL	R ON TC.COPY_ID=R.COPY_ID AND TC.TITLE_ID=R.TITLE_ID;
SELECT * FROM V_TITLE_AVAIL;

--8--
SELECT * FROM TITLE_COPY;
INSERT INTO TITLE
VALUES (TITLE_ID_SEQ.NEXTVAL,'스타워즈', '스타워즈 설명', '전체가', 'SF', '77/07/07');
INSERT INTO TITLE_COPY
VALUES (1,98,'대여가능');
INSERT INTO TITLE_COPY
VALUES (2,98,'대여가능');
--8B--
SELECT * FROM TITLE;
INSERT INTO RESERVATION
VALUES(SYSDATE,102,98);
INSERT INTO RESERVATION
VALUES (SYSDATE,106,96);
--8C--
DELETE RESERVATION WHERE TITLE_ID=98;
SELECT * FROM RENTAL;
INSERT INTO RENTAL
VALUES(SYSDATE,102,1,98,DEFAULT,DEFAULT);

CREATE OR REPLACE VIEW V_COPY_RENTAL_STATUS
AS SELECT	T.TITLE AS TITLE,
			TC.COPY_ID AS COPY_ID,
			TC.STATUS	AS STATUS,
			R.EXP_RET_DATE AS EXP_RET_DATE
	FROM	TITLE T
	FULL JOIN	TITLE_COPY TC ON T.TITLE_ID=TC.TITLE_ID
	FULL JOIN	RENTAL	R ON TC.COPY_ID=R.COPY_ID AND TC.TITLE_ID=R.TITLE_ID;
SELECT * FROM V_COPY_RENTAL_STATUS;

--9--
ALTER TABLE TITLE ADD (PRICE NUMBER(5));
SELECT * FROM TITLE;
UPDATE TITLE
SET PRICE = 3000
WHERE TITLE='인어공주';
UPDATE TITLE
SET PRICE = 2500
WHERE TITLE='매트릭스';
UPDATE TITLE
SET PRICE = 2000
WHERE TITLE='에이리언';
UPDATE TITLE
SET PRICE = 3000
WHERE TITLE='모던타임즈';
UPDATE TITLE
SET PRICE = 3500
WHERE TITLE='러브스토리';
UPDATE TITLE
SET PRICE = 2000
WHERE TITLE='람보';
UPDATE TITLE
SET PRICE = 1500
WHERE TITLE='스타워즈';


--10--

CREATE OR REPLACE VIEW V_MEMBER_RENTAL_STATUS
AS SELECT	M.NAME AS 회원명,
			T.TITLE AS 제목,
			R.BOOK_DATE AS 대여일,
			R.EXP_RET_DATE - R.BOOK_DATE AS 기간
	FROM	MEMBER M
	LEFT JOIN	RENTAL	R ON M.MEMBER_ID=R.MEMBER_ID
	JOIN	TITLE_COPY TC ON R.TITLE_ID=TC.TITLE_ID AND R.COPY_ID=TC.COPY_ID
	JOIN 	TITLE T ON T.TITLE_ID=TC.TITLE_ID;
SELECT * FROM V_MEMBER_RENTAL_STATUS;

DROP TABLE WEB_TEST_MEM_TBL;

 CREATE TABLE WEB_TEST_MEM_TBL(
 		ID		VARCHAR2(50)	PRIMARY KEY,
  		PWD		VARCHAR2(50)	NOT NULL,
  		NAME	VARCHAR2(50)	,
  		DEPT	VARCHAR2(50)	DEFAULT '인사(임)',
  		POINT	NUMBER			DEFAULT 0
 );
 INSERT INTO WEB_TEST_MEM_TBL
VALUES ('jssim','jssim','jssim','인사(임)',0 );
COMMIT