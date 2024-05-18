use Resturant;
Go
create table staff(
staff_Id int primary key identity(1,1),
password varchar(20) not null ,
role varchar(10) not null,
staff_name varchar(20) not null,
salary decimal(8,2) not null,
)
create table customer(
customer_name varchar(20) not null,
customer_number varchar(30) primary key,
email varchar(15) not null,
address varchar(30)not null,
)
create table food(
name varchar(15) not null,
food_id int primary key identity(1,1),
description varchar(50)not null,
status varchar(25) not null,
price decimal(7,2)not null,
)
create table menu(
menu_id int primary key identity(1,1),
food_id int,
staff_id int,
foreign key (food_id) references food(food_id),
foreign key (staff_id) references staff(staff_id),
)
create table order_customer(
 order_id int primary key identity(1,1),
 order_date date not null,
 total_amount decimal(7,2) not null,
 staff_id int,
 food_id int,
 customer_number varchar(30) ,
 order_status varchar(15) not null,    
 foreign key (customer_number) references customer(customer_number),
 foreign key (food_id) references food(food_id),
 foreign key (staff_id) references staff(staff_id),
)
create table table_reservation(
table_id int primary key identity(1,1),
staff_id int ,
food_id int,
customer_number varchar(30) ,
number_of_people int not null,
reservation_date date not null,
status varchar(10) not null,
 foreign key (customer_number) references customer(customer_number),
 foreign key (food_id) references food(food_id),
 foreign key (staff_id) references staff(staff_id),
)
create table delivary(
staff_id int ,
customer_number varchar(30)not null,
order_id int,
date_deli date,
foreign key (customer_number) references customer(customer_number),
foreign key (staff_id) references staff(staff_id),
foreign key (order_id) references order_customer(order_id),
)
create table payment(
pay_id int primary key identity(1,1),
customer_number varchar(30),
order_id int,
foreign key (customer_number) references customer(customer_number),
foreign key (order_id) references order_customer(order_id),
)
ALTER TABLE customer
ALTER COLUMN email VARCHAR(50);
insert into staff(staff_name,password,role,salary)
values
('tamer','12345678','admin',1200),
('salah','12345679','manage',1500),
('adam','12345671','waiter',1000),
('farah','12345672','waitress',1000);
INSERT INTO food (name, description, status, price) VALUES
('macronna', 'Delicious pasta', 'Available', 25),
('rice', 'Steamed rice', 'Available', 26),
('chicken', 'Grilled chicken', 'Available', 27);
INSERT INTO menu(food_id,staff_id) 
VALUES
    ((SELECT food_id FROM food WHERE name = 'rice'), 1),
    ((SELECT food_id FROM food WHERE name = 'chicken'), 2);
SELECT m.*, f.name, f.price + 1 AS updated_price
FROM menu AS m
JOIN food AS f ON m.food_id = f.food_id
JOIN staff AS s ON s.staff_Id = m.staff_id
WHERE s.role IN ('admin', 'manage');
insert into customer(customer_name,customer_number,email,address)
values
('ahmed','01023457102','ahmed@gmail.com','dokii'),
('sara','01023457100','sara@gmail.com','ramsis'),
('ahlam','01023457130','ahlam@gmail.com','zmalek'),
('mohamed','01023457110','mohamed@gmail.com','ramsis');
INSERT INTO table_reservation(staff_id, food_id, customer_number, number_of_people, reservation_date, status)
VALUES
(1, (SELECT food_id FROM food WHERE name = 'macronna'), '01023457100', 2, '2024-05-06', 'accept'),
(2, (SELECT food_id FROM food WHERE name = 'rice'), '01023457102', 4, '2024-05-06', 'reject'),
(3, (SELECT food_id FROM food WHERE name = 'chicken'), '01023457130', 3, '2024-05-06', 'accept'),
(4, (SELECT food_id FROM food WHERE name = 'macronna'), '01023457110', 1, '2024-05-06', 'reject');
update table_reservation
set number_of_people+=1
where status='accept';
update table_reservation
set reservation_date='2024-05-07'
where status='accept';
select *
from table_reservation
where status='accept';
insert into order_customer(order_date,total_amount,staff_id,food_id,customer_number,order_status)
values
('2024-05-07',50.00,3,(SELECT food_id FROM food WHERE name = 'chicken'),'01023457130','pending'),
('2024-05-07',30.00,1,(SELECT food_id FROM food WHERE name = 'macronna'),'01023457100','pending');
insert into payment(order_id,customer_number)
values
((SELECT MAX(order_id) FROM order_customer WHERE customer_number = '01023457130'),'01023457130'),
((SELECT MAX(order_id) FROM order_customer WHERE customer_number = '01023457100'),'01023457100');
select oc.order_id,oc.food_id,oc.order_date,p.pay_id,oc.total_amount
from order_customer oc left outer join payment p
on oc.order_id=p.order_id
group by oc.order_id,p.pay_id,oc.food_id,oc.order_date,oc.total_amount;

/*delete order_customer;
delete payment;
delete menu;
delete food;
delete staff;
delete customer;
delete table_reservation;
delete delivary;*/