create table payment(
Payment_ID int auto_increment,
Order_ID int NOT NULL,
Payment_Date timestamp default current_timestamp,
Payment_Mode varchar(100) NOT NULL,
Payment_Status varchar(100) NOT NULL,
Transaction_Amount decimal(10,2),

constraint pk_key primary key (Payment_ID),
constraint chk_amt CHECK(Transaction_Amount > 0),
constraint fk_key foreign key (Order_ID)  references orders(Order_ID)
);
select * FROM Orders;
insert into payment (Order_ID,Payment_Mode,Payment_Status,Transaction_Amount) values
(1,"upi","pending",450),
(2,"credit card","successfull",4056),
(3,"debit card","failed",5760),
(4,"upi","successfull",950);

select * FROM payment;
-- all pay display.

-- successfull transaction
select * from payment where Payment_Status = "successfull";

-- failed transaction
select * from payment where Payment_Status = "failed";

-- count total successfull and failed payment
select 
count(*) as Number_of_Transaction,Payment_Mode
from payment group by Payment_Mode;

select 
count(*) as Number_of_Transaction,Payment_Status
from payment group by Payment_Status;

select * from payment where Payment_Status = "failed";

-- update failed payment after retry.
update payment set Payment_Status = "successfull" where Payment_ID = 10;

-- Identify pending transactions.
select * from payment where Payment_Status = "Pending";





