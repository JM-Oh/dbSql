--�������� Ȱ��ȭ / ��Ȱ��ȭ
--� ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���?

--emp fk���� (dept���̺��� deptno�÷� ����)
--FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

--�������ǿ� ����Ǵ� �����Ͱ� �� �� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

--FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;
--�������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)�� �����Ͽ� �������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

--FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;
COMMIT;

--���� ������ �����ϴ� ���̺� ��� view : USER_TABLES
--���� ������ �����ϴ� ���� ���� view : USER_CONTRAINTS
--���� ������ �����ϴ� ���� ������ �÷� view : USER_CONS_COLUMNS
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP';

SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'FK_CYCLE';

--���̺��� ������ �������� ��ȸ (VIEW ����)
--���̺� �� / �������� �� / �÷��� / �÷� ������
SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P' --PRIMARY KEY�� ��ȸ
ORDER BY a.table_name, b.position;

--emp���̺��� 8���� �÷� �ּ��ޱ�
--EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO

--���̺� �ּ� view : USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

--emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

--emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

--EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

--�ǽ�(comment1)
--user_tab_comment, user_col_comments view�� �̿�
--customer, product, cycle, daily ���̺��� �÷��� �ּ� ������ ��ȸ�ϴ� ����
SELECT *
FROM user_tab_comments;
SELECT *
FROM user_col_comments;

SELECT t.table_name, table_type, t.comments tab_comment, column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name
AND t.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

--VIEW ���� (emp���̺����� sal, comm �ΰ� �÷� �����Ѵ�.)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);

--VIEW (�� �ζ��� ��� �����ϴ�.)
SELECT *
FROM v_emp;

--���ε� ���� ����� VIEW�� ���� : v_emp_dept
--emp, dapt : �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dname, empno, ename, job, hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--VIEW ����
DROP VIEW v_emp;

--VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����.
--deptno 30 = SALES
SELECT *
FROM dept;

--dept���̺��� SALES -> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;
ROLLBACK;

--HR�������� v_emp_dept view ��ȸ������ �ش�.
GRANT SELECT ON v_emp_dept TO hr;


--SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
AND title = '�������� ����ִ�'
AND reg_dt = TO_DATE();

SELECT *
FROM post
WHERE post_id = 1;

--������ ����
--������ : �ߺ����� �ʴ� �������� �������ִ� ��ü
--1, 2, 3, ...

DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
);

CREATE SEQUENCE seq_emp_test;
INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown');

SELECT seq_emp_test.nextval
FROM dual;

ROLLBACK;

SELECT *
FROM emp_test;

--index
--rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺��� �����ϴ� ���� �����ϴ�.

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFNDAAFAAAAFNAAA';

--table : pid, pnm
--pk product : pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFNDAAFAAAAFNAAA';

--�����ȹ�� ���� �ε��� ��뿩�� Ȯ��
--emp ���̺��� empno �÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

--�ε����� ���� ������ empno = 7369�� �����͸� ã�� ���� 
--emp���̺� ��ü�� ã�ƺ����Ѵ�. -> TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)