create table employeenew(
e_id number primary key,
e_name varchar2(10) NOT NULL,
e_addr varchar2(15),
e_phone_no number(10) NOT NULL,
e_job_des varchar2(10) NOT NULL,
e_sal number,
e_bld_grp varchar2(5)
);
create table patientnew(
p_id number primary key,
e_id number REFERENCES employeenew(e_id) NOT NULL,
p_name varchar2(10) NOT NULL,
p_addr varchar2(15),
p_cont_no number(10) NOT NULL,
p_dt_admn varchar2(10),
p_dt_dis varchar2(10),
p_bld_grp varchar2(5) NOT NULL
);
create table doctornew(
e_id number REFERENCES employeenew(e_id) NOT NULL,
p_id number REFERENCES patientnew(p_id),
d_name varchar2(10) NOT NULL,
d_spe varchar2(15)
);
create table nursenew(
e_id number REFERENCES employeenew(e_id) NOT NULL,
p_id number REFERENCES patientnew(p_id),
n_name varchar2(10)
);
create table rec_listnew(
e_id number REFERENCES employeenew(e_id) NOT NULL,
r_name varchar2(10)
);
create table recordsnew(
r_number varchar2(10) primary key,
p_id number REFERENCES patientnew(p_id) NOT NULL,
e_id number REFERENCES employeenew(e_id) NOT NULL,
e_type varchar2(10),
r_details varchar2(15)
);
create table roomnew(
r_record_id number primary key,
r_number number NOT NULL,
r_type varchar2(10),
p_id number REFERENCES patientnew(p_id),
e_id number REFERENCES employeenew(e_id),
e_type varchar2(10)
);
create table medicinesnew(
med_id number primary key,
p_id number REFERENCES patientnew(p_id) NOT NULL,
m_quan number NOT NULL,
m_name varchar2(10)NOT NULL,
m_price number NOT NULL
);

--relation between employee and patient
select employeenew.e_name,employeenew.e_id,patientnew.p_name,patientnew.p_id,patientnew.p_addr from employeenew,patientnew where employeenew.e_id=patientnew.e_id; 

--total price
select patientnew.p_name,patientnew.p_id,medicinesnew.m_quan,medicinesnew.m_price,medicinesnew.m_price*medicinesnew.m_quan as total_price from patientnew,medicinesnew where patientnew.p_id=medicinesnew.p_id;

--procedures for insert in employee
CREATE OR REPLACE PROCEDURE insertnewemployee(
a_id IN employeenew.e_id%TYPE,
a_name IN employeenew.e_name%TYPE,
a_address IN employeenew.e_addr%TYPE,
a_phone_no IN employeenew.e_phone_no%TYPE,
a_job_des IN employeenew.e_job_des%TYPE,
a_salary IN employeenew.e_sal%TYPE,
a_blood_group IN employeenew.e_bld_grp%TYPE
)
IS
BEGIN
INSERT INTO employeenew(e_id,e_name,e_addr,e_phone_no,e_job_des,e_sal,e_bld_grp)
values(a_id,a_name,a_address,a_phone_no,a_job_des,a_salary,a_blood_group);
END;
/

--Example
BEGIN insertnewemployee('1007','shlok','GOTA_Ahmedabad',6785438901,'Nurse',13000,'A-');
end;
BEGIN insertforemployee3('1008','shruti','jaipur',6785444901,'Receptionist',16000,'B-');
end;

--procedure for update in employee'
create or replace procedure updateforemployee(
s_id IN employeenew.e_id%TYPE,
bld_grp IN employeenew.e_bld_grp%TYPE)
IS
BEGIN
UPDATE employeenew SET e_bld_grp=bld_grp WHERE s_id=e_id ;
end;
/

--Example
BEGIN updateforemployee('1001','O+');
end;

--check
select * from employee3;

--procedure fro delete in employee
create or replace procedure deleteemployee(
k_id IN employeenew.e_id%TYPE)
IS
BEGIN
delete from employeenew WHERE k_id=e_id ;
end;
/

--Example
BEGIN deleteemployee('1007');
end;

--trigger from employee
CREATE OR REPLACE TRIGGER errorinemployee
before 
insert or update
on employeenew
for each row
begin
if length(:new.e_phone_no)<>10 then 
raise_application_error(-20005,'Phone Number is Incorrect');
end if;
end;

--Example
insert into employeenew values('1022','jinay','itli',78345692,'new',1000,'Y-');

--cursor
set serveroutput on;
declare 
i number:=0; 
cursor test is select e_id,e_name,e_sal from employeenew order by e_sal desc; 
r test%rowtype;  
begin 
open test; 
loop  
        exit when i=4;
 	fetch test into r; 
 	dbms_output.put_line(r.e_id||' '||r.e_name||' '||r.e_sal); 
 i:=i+1; 
 end loop; 
 close test; 
 end;
 /