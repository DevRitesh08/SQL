show databases;

use test;


CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT ,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT '2025-07-16',

    constraint UNIQUE_orderid UNIQUE(OrderID),
    constraint orderId_check check(OrderID > 5)
);

insert into orders values
(30, 8, '2025-07-16'),
(30, 9, '2025-07-16');

drop table IF EXISTS Orders;




