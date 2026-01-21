-- Create database CSDL_session07_02
create database CSDL_session07_02;
-- Create table customer
create table customer(
	customer_id serial primary key,
	full_name varchar(100),
	email varchar(100),
	phone varchar(15)
);
-- Create table orders
create table orders(
	order_id serial primary key,
	customer_id int references customer(customer_id),
	total_amount decimal(10,2),
	order_date date
);
insert into customer (full_name, email, phone) values
('Nguyễn Văn An', 'an.nguyen@email.com', '0901112233'),
('Trần Thị Bích', 'bich.tran@email.com', '0912223344'),
('Lê Minh Cường', 'cuong.le@email.com', '0983334455'),
('Phạm Thu Dung', 'dung.pham@email.com', '0974445566'),
('Hoàng Quốc Bảo', 'bao.hoang@email.com', '0965556677'),
('Vũ Thị Hạnh', 'hanh.vu@email.com', '0956667788'),
('Đặng Ngọc Long', 'long.dang@email.com', '0947778899'),
('Bùi Phương Thảo', 'thao.bui@email.com', '0938889900'),
('Đỗ Văn Kiên', 'kien.do@email.com', '0929990011'),
('Hồ Thị Mai', 'mai.ho@email.com', '0910001122'),
('Ngô Thanh Tùng', 'tung.ngo@email.com', '0901122334'),
('Dương Mỹ Linh', 'linh.duong@email.com', '0982233445'),
('Lý Văn Hùng', 'hung.ly@email.com', '0973344556'),
('Vương Thị Tuyết', 'tuyet.vuong@email.com', '0964455667'),
('Trịnh Quang Huy', 'huy.trinh@email.com', '0955566778');

insert into orders (customer_id, total_amount, order_date) values
(1, 550000.00, '2023-10-01'),
(2, 1250000.00, '2023-10-03'),
(1, 300000.00, '2023-10-05'),
(3, 4500000.00, '2023-10-10'),
(4, 150000.00, '2023-10-12'),
(5, 2100000.00, '2023-10-15'),
(2, 780000.00, '2023-10-20'),
(6, 950000.00, '2023-10-22'),
(7, 3200000.00, '2023-10-25'),
(8, 600000.00, '2023-11-01'),
(9, 1100000.00, '2023-11-05'),
(10, 250000.00, '2023-11-10'),
(11, 890000.00, '2023-11-15'),
(5, 1750000.00, '2023-11-20'),
(12, 4000000.00, '2023-11-25');

select * from customer;
select * from orders;
--Tạo một View tên v_order_summary hiển thị:
-- full_name, total_amount, order_date
-- (ẩn thông tin email và phone)
create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c join orders o on c.customer_id = o.customer_id;

-- Viết truy vấn để xem tất cả dữ liệu từ View
select * from v_order_summary;

-- Cập nhật tổng tiền đơn hàng thông qua View (gợi ý: dùng WITH CHECK OPTION nếu cần)
create or replace view v_high_value_orders as
select order_id, total_amount, order_date
from orders
where total_amount > 1000000
with check option;

update v_high_value_orders
set total_amount = 5000000
where order_id = 2;

-- Tạo một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
create or replace view v_monthly_sales as
select
to_char(order_date, 'YYYY-MM') as sale_month,
sum(total_amount) as total_revenue
from orders
group by to_char(order_date, 'YYYY-MM')
order by sale_month;

select * from v_monthly_sales;

-- Thử DROP View và ghi chú sự khác biệt giữa DROP VIEW và DROP MATERIALIZED VIEW trong PostgreSQL
drop view if exists v_monthly_sales;
-- view là bảng ảo và chỉ lưu trữ câu lệnh truy vấn, không lưu trữ dữ liệu
-- drop view - chỉ xóa các câu lệnh khỏi hệ thống (nhanh, không giải phóng dung lượng)
-- materialized view là bản chụp dữ liệu thật, lưu trữ cả câu lệnh truy vấn và kết quả dữ liệu vào ổ cứng
-- drop materialized view xóa cả các câu lệnh và xóa cả tệp dữ liệu lưu trên ổ cứng (giải phóng dung lượng)