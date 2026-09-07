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
<img width="644" height="166" alt="image" src="https://github.com/user-attachments/assets/e2b9f8b4-2e3b-40c9-b540-7dc7a9baeca9" />

insert into payment (Order_ID,Payment_Mode,Payment_Status,Transaction_Amount) values
(1,"upi","pending",450),
(2,"credit card","successfull",4056),
(3,"debit card","failed",5760),
(4,"upi","successfull",950);

select * FROM payment;
<img width="890" height="254" alt="image" src="https://github.com/user-attachments/assets/d3303b72-0f75-496c-ae54-8df0a8ff8617" />

-- all pay display.

-- successfull transaction
select * from payment where Payment_Status = "successfull";

-- failed transaction
select * from payment where Payment_Status = "failed";

-- count total successfull and failed payment
select 
count(*) as Number_of_Transaction,Payment_Mode
from payment group by Payment_Mode;
<img width="409" height="119" alt="image" src="https://github.com/user-attachments/assets/0cc8cbca-8c4b-4d6a-991c-a93d46b463de" />


select 
count(*) as Number_of_Transaction,Payment_Status
from payment group by Payment_Status;
<img width="381" height="94" alt="image" src="https://github.com/user-attachments/assets/6444ef60-c66f-4141-93d2-3410645ace27" />

select * from payment where Payment_Status = "failed";
<img width="849" height="62" alt="image" src="https://github.com/user-attachments/assets/26d04dae-8b00-4eda-8e8b-5909631582ef" />

-- update failed payment after retry.
update payment set Payment_Status = "successfull" where Payment_ID = 10;

-- Identify pending transactions.
select * from payment where Payment_Status = "Pending";
<img width="913" height="150" alt="image" src="https://github.com/user-attachments/assets/c1a948b6-7e47-4c26-a4bf-7d20dd972085" />






