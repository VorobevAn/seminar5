create table if not exists auto (
	id int auto_increment primary key,
    name varchar(50) not null,
    cost decimal (10, 2) check (cost > 0));
    
    insert into auto (name, cost) values
('Audi', 52642.00),
('Mersedes', 57127.00),
('Skoda', 9000.00),
('Volvo', 29000.00),
('Bently', 350000.00),
('Citroen', 21000.00),
('Hummer', 41400.00),
('Volkswagen', 21600.00);

select * from auto;
-- 1.	Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов

CREATE or replace VIEW CheapCars AS 
SELECT * FROM auto
WHERE cost<25000;

select * from CheapCars;

/* 2.	Изменить в существующем представлении порог для стоимости: 
 пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) */

ALTER VIEW CheapCars as
select* from auto 
where cost < 30000;

select * from CheapCars;

-- 3 Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично)
create or replace view cars as
select * from auto
where name in ('Skoda', 'Audi');

select* from cars;

-- 2 задача: Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.


    create table if not exists Groupses(
	gr_id int auto_increment primary key,
    gr_name varchar(100) not null,
    gr_temp int);
    
create table if not exists Analysis( 
	an_id int auto_increment primary key,
    an_name varchar(100) not null,
    an_cost int,
    an_price int,
    an_group int,
    foreign key (an_group) references Groupses(gr_id) );
    
    
    create table if not exists Orders(
	ord_id int auto_increment primary key,
    ord_datetime timestamp,
    ord_an int,
	foreign key (ord_an) references Analysis(an_id));
    
insert into Groupses (gr_name, gr_temp) values
('Анальгетики', 5),
('Витамины', 18),
('Противовирусные', 10);

insert into Analysis (an_name, an_cost, an_price, an_group) values 
('краткий', 100, 300, 1),
('структурный', 250, 400, 1),
('полный', 300, 450.00, 2),
('комбинированный', 450, 1125.00, 2);


insert into Orders (ord_datetime, ord_an) values
('2020-02-04 09:00:00', 1),
('2020-02-05 10:00:00', 2),
('2020-02-06 13:30:00', 3),
('2020-02-07 15:30:00', 4),
('2020-02-09 12:00:00', 2),
('2020-02-10 11:30:00', 1),
('2020-02-12 14:30:00', 3),
('2020-02-13 12:30:00', 2),
('2020-02-14 11:00:00', 1);


select an_name 'анализ', an_price'цена', ord_datetime'дата анализа'
from Analysis as a
join (select * from Orders 
where ord_datetime regexp '2020-02-([0][5-9]|[1][0-2])') as o
on a.an_id = o.ord_an
ORDER by ord_datetime;

-- Задача 3

create table if not exists Travel (
	train_id int,
    station varchar(20) not null,
    station_time time
);

insert into Travel (train_id, station, station_time) values
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:02:00'),
(120, 'San Jose', '13:30:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(110, 'San Jose', '12:35:00');

select * from Travel;
/*
Добавьте новый столбец под названием «время до следующей станции». 
Вычислите время в пути для пар смежных станций. 
*/

select *, 
timediff(lead(station_time) over 
(partition by train_id order by station_time), station_time) 'время до следующей станции' 
from Travel;

