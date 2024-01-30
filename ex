create type invoice_status as enum ('NEW', 'PAID', 'WAITING FOR PAYMENT');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE Invoices (
    id SERIAL PRIMARY KEY,
    buyer VARCHAR(255),
    seller VARCHAR(255),
    value DECIMAL(10,2),
    account_number VARCHAR(20),
    status invoice_status
);
INSERT INTO Invoices (buyer, seller, value, account_number, status)
VALUES
    ('Company1', 'Company2', 100.00, '123456789', 'NEW'),
    ('Company3', 'Company4', 200.50, '987654321', 'PAID'),
    ('Company5', 'Company6', 50.25, '456789012', 'WAITING FOR PAYMENT');
select * from Invoices where status = 'NEW';

alter table Invoices add column internal_id UUID default uuid_generate_v4();
update Invoices set internal_id = uuid_generate_v4() where true;
select * from Invoices;

alter table Invoices add column json_data JSON;
alter table Invoices add column jsonb_data JSONB;
update Invoices set json_data = '{"buyer": "company a", "seller": "company b", "status": "NEW", "account_number": 123321123, "value": 23.43}',
    jsonb_data = '{"buyer": "company a", "seller": "company b", "status": "NEW", "account_number": 123321123, "value": 23.43}'
	where true;

alter table Invoices add column phone_numbers varchar(20)[];
update Invoices set phone_numbers = array['123211233', '125433221', '127643454'] where id = 3;
update Invoices set phone_numbers = array['432323112', '123344311'] where id = 2;
select buyer, phone_numbers[array_length(phone_numbers, 1)] as last_phone_number from Invoices where id = 3;
select * from Invoices where '432323112' = any(phone_numbers);

alter table Invoices add column file_data BYTEA;
update Invoices set file_data = pg_read_binary_file('/home/dci-student/Desktop/name.txt') where id = 1;

alter table Invoices add column payment_deadline DATE;
alter table Invoices add column transaction_time TIMESTAMPTZ;
alter table Invoices add column transaction_hour TIME;
alter table Invoices add column cyclic_payment INTERVAL;
update Invoices set 
	payment_deadline = '2023-12-31',
    transaction_time = CURRENT_TIMESTAMP,
    transaction_hour = CURRENT_TIME,
    cyclic_payment = '1 month'
where true;
update Invoices set transaction_time = transaction_time at TIME ZONE  'Australia/Melbourne';
update Invoices set transaction_hour = transaction_hour at TIME ZONE  'Australia/Melbourne';
select transaction_time + interval '10 hours' from Invoices;



