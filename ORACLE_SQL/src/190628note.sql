select * from SAL_GRADE;

select EMP_NAME, DEPT_NAME
from	EMPLOYEE E,
		DEPARTMENT D
where E.DEPT_ID = D.DEPT_ID;

select	EMP_NAME, DEPT_NAME
from	EMPLOYEE
join	DEPARTMENT using(DEPT_ID)
where	JOB_ID ='J6';

select	EMP_NAME,
		DEPT_NAME,
		LOC_DESCRIBE,
		COUNTRY_NAME
from	DEPARTMENT
join	LOCATION on (LOC_ID = LOCATION_ID)
join	COUNTRY using(COUNTRY_ID)
join	EMPLOYEE using(DEPT_ID);

--중요!!! 외래키로 연결되지 않는 두 테이블도 조인할 수 있다.--
select	EMP_NAME,
		SALARY,
		SLEVEL
from	EMPLOYEE E
join	SAL_GRADE S on (SALARY between S.LOWEST and S.HIGHEST)
order by SLEVEL;

--oracle 전용 레프트 라이트 조인--
select	EMP_NAME,
		DEPT_NAME
from	EMPLOYEE E, DEPARTMENT D
where	E.DEPT_ID = D.DEPT_ID(+)

--ANSI표준 레프트 라이트 조인--
select	EMP_NAME, DEPT_NAME
from	EMPLOYEE
left 	join DEPARTMENT USING (DEPT_ID)
order by 1;

select	EMP_NAME, DEPT_NAME
from	EMPLOYEE
right 	join DEPARTMENT USING (DEPT_ID)
order by 1;

select	EMP_NAME, DEPT_NAME
from	EMPLOYEE
full 	join DEPARTMENT USING (DEPT_ID)
order by 1;

--동일 테이블을 조인 -> 별칭을 사용해야한다.--
select	E.EMP_NAME as 직원,
		M.EMP_NAME as 관리자,
		S.EMP_NAME as 슈퍼바이저
from	EMPLOYEE E
left join	EMPLOYEE M on (E.MGR_ID = M.EMP_ID)
left join	EMPLOYEE S on (M.MGR_ID = S.EMP_ID)	
order by 1;

select	EMP_NAME,
		DEPT_NAME
from	EMPLOYEE
join	JOB using (JOB_ID)
join	DEPARTMENT using (DEPT_ID)
join	LOCATION on LOC_ID=LOCATION_ID
where	JOB_TITLE='대리'
and		LOC_DESCRIBE like '아시아%';

select	EMP_NAME,
		JOB_TITLE,
		SLEVEL,
		DEPT_NAME,
		COUNTRY_NAME,
		LOC_DESCRIBE		
from	EMPLOYEE
join	JOB using(JOB_ID)
join	SAL_GRADE on (SALARY between LOWEST and HIGHEST)
join	DEPARTMENT using (DEPT_ID)
join	LOCATION on (LOC_ID=LOCATION_ID)
join	COUNTRY using (COUNTRY_ID);
		

select	EMP_NAME,
		JOB_ID,
		SALARY
from	EMPLOYEE
where	JOB_ID	= (	select JOB_ID
					from	EMPLOYEE
					where	EMP_NAME = '나승원')
and		SALARY > (	select SALARY
					from	EMPLOYEE
					where	EMP_NAME = '나승원');

select	EMP_NAME,
		JOB_ID,
		SALARY
from	EMPLOYEE
where	SALARY = (	select	MIN(SALARY)
					from	EMPLOYEE	);
					
select	DEPT_NAME,
		SUM(SALARY)
from	EMPLOYEE
left join	DEPARTMENT using (DEPT_ID)
group by	DEPT_ID, DEPT_NAME
having	SUM(SALARY)= (	select	MAX(SUM(SALARY))
						from	EMPLOYEE
						group by	DEPT_ID		);
						

SELECT	EMP_ID,
		EMP_NAME,
		'관리자'AS 구분
FROM	EMPLOYEE
WHERE	EMP_ID IN (SELECT MGR_ID FROM EMPLOYEE)
UNION
SELECT	EMP_ID,
		EMP_NAME,
		'직원'
FROM	EMPLOYEE
WHERE	EMP_ID NOT IN (SELECT MGR_ID FROM EMPLOYEE
						WHERE MGR_ID IS NOT NULL)
ORDER BY 3,1;


SELECT	EMP_NAME,
		SALARY
FROM	EMPLOYEE
JOIN	JOB USING (JOB_ID)
WHERE	JOB_TITLE ='대리'
AND		SALARY > ANY 
				   (SELECT SALARY
					FROM	EMPLOYEE
					JOIN	JOB USING (JOB_ID)
					WHERE	JOB_TITLE ='과장' );


SELECT	EMP_NAME,
		SALARY
FROM	EMPLOYEE
JOIN	JOB USING (JOB_ID)
WHERE	JOB_TITLE ='대리'
AND		SALARY < ANY 
				   (SELECT SALARY
					FROM	EMPLOYEE
					JOIN	JOB USING (JOB_ID)
					WHERE	JOB_TITLE ='과장' );

SELECT	EMP_NAME,
		SALARY
FROM	EMPLOYEE
JOIN	JOB USING (JOB_ID)
WHERE	JOB_TITLE ='대리'
AND		SALARY < ALL 
				   (SELECT SALARY
					FROM	EMPLOYEE
					JOIN	JOB USING (JOB_ID)
					WHERE	JOB_TITLE ='과장' );
					
SELECT	EMP_NAME,
		SALARY
FROM	EMPLOYEE
JOIN	JOB USING (JOB_ID)
WHERE	JOB_TITLE ='대리'
AND		SALARY > ALL 
				   (SELECT SALARY
					FROM	EMPLOYEE
					JOIN	JOB USING (JOB_ID)
					WHERE	JOB_TITLE ='과장' );
						
SELECT	EMP_NAME,
		JOB_TITLE,
		SALARY
FROM	(SELECT JOB_ID,
				TRUNC(AVG(SALARY),-5) AS JOBAVG
		 FROM	EMPLOYEE
		 GROUP BY JOB_ID ) V --다중열 다중행 서브쿼리--
JOIN	EMPLOYEE E ON
		(JOBAVG = SALARY AND
		 NVL(E.JOB_ID, ' ') = NVL(V.JOB_ID, ' '))
LEFT JOIN	JOB J ON (E.JOB_ID = J.JOB_ID)
ORDER BY E.JOB_ID;
		
-------------WORKBOOK 13pg------------

--1--

SELECT	STUDENT_NAME AS 학생이름,
		STUDENT_ADDRESS AS 주소지
FROM 	TB_STUDENT
ORDER BY 학생이름;

--2--						

SELECT	STUDENT_NAME,
		STUDENT_SSN
FROM	TB_STUDENT
WHERE	ABSENCE_YN ='Y'
ORDER BY STUDENT_SSN DESC;
						
--3--

SELECT	STUDENT_NAME AS 학생이름,
		STUDENT_NO	AS 학번,
		STUDENT_ADDRESS AS "거주지 주소"
FROM	TB_STUDENT
WHERE	STUDENT_NO LIKE '9%'
AND		(STUDENT_ADDRESS LIKE '%강원도%'
OR		STUDENT_ADDRESS LIKE '%경기도%')
ORDER BY	학생이름;

--4--

SELECT	PROFESSOR_NAME,
		PROFESSOR_SSN
FROM	TB_PROFESSOR
WHERE	DEPARTMENT_NO = (SELECT DEPARTMENT_NO
						 FROM	TB_DEPARTMENT
						 WHERE DEPARTMENT_NAME='법학과')
ORDER BY PROFESSOR_SSN;


--5!--
SELECT	STUDENT_NO,
		POINT
FROM	TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE	CLASS_NO='C3118100'
AND		TERM_NO='200402'
ORDER BY POINT DESC;

--6?--

SELECT	STUDENT_NO,
		STUDENT_NAME,
		DEPARTMENT_NAME
FROM	TB_STUDENT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

--7--

SELECT	CLASS_NAME,
		DEPARTMENT_NAME
FROM	TB_DEPARTMENT JOIN TB_CLASS USING(DEPARTMENT_NO)
ORDER BY DEPARTMENT_NAME;

--8--

SELECT	CLASS_NAME,
		PROFESSOR_NAME
FROM	TB_CLASS
JOIN	TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN	TB_PROFESSOR USING(PROFESSOR_NO)
ORDER BY	PROFESSOR_NAME;

--9--
SELECT	C.CLASS_NAME,
		P.PROFESSOR_NAME
FROM	TB_CLASS C
JOIN	TB_CLASS_PROFESSOR CP ON C.CLASS_NO = CP.CLASS_NO
JOIN	TB_PROFESSOR P ON CP.PROFESSOR_NO = P.PROFESSOR_NO
WHERE	C.DEPARTMENT_NO IN (SELECT DEPARTMENT_NO
						  FROM	TB_DEPARTMENT
						  WHERE CATEGORY='인문사회');

--10--
SELECT	STUDENT_NO 학번,
		STUDENT_NAME "학생 이름",
		ROUND(AVG(POINT),1) "전체 평점"
FROM	TB_STUDENT
JOIN	TB_GRADE USING(STUDENT_NO)
WHERE	DEPARTMENT_NO IN (SELECT DEPARTMENT_NO
						  FROM	TB_DEPARTMENT
						  WHERE	DEPARTMENT_NAME='음악학과')
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;


--11--

SELECT	D.DEPARTMENT_NAME 학과이름,
		S.STUDENT_NAME 학생이름,
		P.PROFESSOR_NAME 지도교수이름
FROM	TB_DEPARTMENT D
JOIN	TB_STUDENT S ON D.DEPARTMENT_NO = S.DEPARTMENT_NO
JOIN	TB_PROFESSOR P ON S.COACH_PROFESSOR_NO=P.PROFESSOR_NO
WHERE	S.STUDENT_NO='A313047';

--12--

SELECT	STUDENT_NAME,
		TERM_NO
FROM	TB_STUDENT
JOIN	TB_GRADE USING(STUDENT_NO)
WHERE	TERM_NO LIKE'2007%'
AND		CLASS_NO = (SELECT CLASS_NO
					 FROM	TB_CLASS
					 WHERE	CLASS_NAME='인간관계론'
					 AND CLASS_NAME IS NOT NULL);
						
--13--					

SELECT	CLASS_NAME,
		DEPARTMENT_NAME
FROM	TB_CLASS C
LEFT JOIN	TB_DEPARTMENT D ON C.DEPARTMENT_NO= D.DEPARTMENT_NO
LEFT JOIN	TB_CLASS_PROFESSOR CP ON C.CLASS_NO=CP.CLASS_NO
WHERE	CATEGORY='예체능'
AND		PROFESSOR_NO IS NULL;


--14--

SELECT	S.STUDENT_NAME 학생이름,
		NVL(P.PROFESSOR_NAME, '지도교수미지정') 지도교수
FROM	TB_STUDENT S
LEFT JOIN	TB_PROFESSOR P ON S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
WHERE	S.DEPARTMENT_NO = (SELECT	DEPARTMENT_NO
						 FROM	TB_DEPARTMENT
						 WHERE	DEPARTMENT_NAME='서반아어학과')
ORDER BY S.STUDENT_NO;

--15--

SELECT	S.STUDENT_NO 학번,
		S.STUDENT_NAME 이름,
		D.DEPARTMENT_NAME "학과 이름",
		AVG(G.POINT) 평점
FROM	TB_GRADE G
FULL JOIN	TB_STUDENT S ON S.STUDENT_NO=G.STUDENT_NO
FULL JOIN	TB_DEPARTMENT D ON D.DEPARTMENT_NO=S.DEPARTMENT_NO
WHERE	S.ABSENCE_YN='N'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME,D.DEPARTMENT_NAME
HAVING AVG(G.POINT)>=4;


--16--

SELECT	CLASS_NO,
		CLASS_NAME,
		AVG(POINT)
FROM	TB_CLASS
JOIN	TB_GRADE USING(CLASS_NO)
WHERE	DEPARTMENT_NO = (SELECT	DEPARTMENT_NO
					FROM	TB_DEPARTMENT
					WHERE	DEPARTMENT_NAME='환경조경학과')
AND		CLASS_TYPE LIKE '%전공%'
GROUP BY	CLASS_NO,CLASS_NAME;


--17--

SELECT	STUDENT_NAME,
		STUDENT_ADDRESS
FROM	TB_STUDENT
WHERE	DEPARTMENT_NO = (SELECT DEPARTMENT_NO
						 FROM	TB_STUDENT
						 WHERE	STUDENT_NAME = '최경희')

--18--


						 
--19--

SELECT	D.DEPARTMENT_NAME "계열 학과명",
		ROUND(AVG(G.POINT),1) 전공평점
FROM	TB_DEPARTMENT D
JOIN	TB_CLASS C ON D.DEPARTMENT_NO=C.DEPARTMENT_NO
JOIN	TB_GRADE G ON C.CLASS_NO=G.CLASS_NO
WHERE	CATEGORY = (SELECT	CATEGORY
					FROM	TB_DEPARTMENT
					WHERE	DEPARTMENT_NAME='환경조경학과')
AND		C.CLASS_TYPE LIKE '%전공%'
GROUP BY D.DEPARTMENT_NAME;






