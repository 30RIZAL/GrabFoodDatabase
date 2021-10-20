CREATE SEQUENCE seq_ord_number
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  
create or replace function ord_id () returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'#',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql



create table menu_type(
	mety_name varchar(55),
	constraint mety_name_pk primary key (mety_name)
)

create table resto_category (
	reca_name varchar(15),
	reca_desc varchar (55),
	constraint reca_name_pk primary key (reca_name)
)

create table users(
	user_id serial,
	user_name varchar(25),
	user_email varchar(55),
	user_password varchar(100),
	user_handphone varchar(15),
	user_roles varchar(25),
	constraint user_id_pk primary key (user_id)
)

create table address(
	addr_id serial,
	addr_name varchar (255),
	addr_detail varchar(55),
	addr_lalitude varchar (200),
	addr_longtitude varchar (200),
	addr_user_id integer,
	constraint addr_id_pk primary key (addr_id)
)

create table resto_shop(
	reto_id serial,
	reto_name varchar(155),
	reto_open_hours varchar(30),
	reto_rating integer,
	reto_approval boolean,
	reto_user_id integer,
	reto_reca_name varchar (15),
	constraint reto_id_pk primary key (reto_id),
	foreign key (reto_user_id) references users(user_id) on update cascade on delete cascade,
	foreign key (reto_reca_name) references resto_category on update cascade on delete cascade
)

create table resto_reviews(
	rere_id serial,
	rere_comments varchar(255),
	rere_rating integer,
	rere_user_id integer,
	rere_reto_id integer,
	constraint rere_id_pk primary key (rere_id),
	foreign key (rere_user_id) references users(user_id) on update cascade on delete cascade,
	foreign key (rere_reto_id) references resto_shop(reto_id) on update cascade on delete cascade
)

create table resto_menu(
	reme_id serial,
	reme_name varchar(55),
	reme_desc varchar(255),
	reme_price numeric(15,2),
	reme_url_image varchar(200),
	reme_mety_name varchar(55),
	reme_reto_id integer,
	constraint reme_id_pk primary key (reme_id),
	foreign key (reme_mety_name) references menu_type(mety_name) on update cascade on delete cascade,
	foreign key (reme_reto_id) references resto_shop(reto_id) on update cascade on delete cascade
)

create table carts(
	cart_id serial,
	cart_createdon date,
	cart_status varchar(15),
	cart_reto_id integer,
	cart_user_id integer,
	constraint cart_id_pk primary key (cart_id),
	foreign key (cart_reto_id) references carts(cart_id) on update cascade on delete cascade,
	foreign key (cart_user_id) references users(user_id) on update cascade on delete cascade
)

create table resto_addon(
	redon_id serial,
	redon_name varchar(55),
	redon_price numeric(15,2),
	redon_reme_id integer,
	constraint redon_id_pk primary key (redon_id),
	foreign key (redon_reme_id) references resto_menu(reme_id) on update cascade on delete cascade
)

create table order_menu(
	order_name varchar(15) DEFAULT ord_id(),
	order_created date,
	order_subtotal numeric(18,2),
	order_qty integer,
	order_tax numeric(15,2),
	order_delivery numeric(15,2),
	order_discount numeric (15,2),
	order_promo numeric (15,2),
	order_total_price numeric (15,2),
	order_status varchar(15),
	order_payment_type varchar(15),
	order_payment_trx varchar(15),
	order_user_id integer,
	constraint order_name_pk primary key (order_name),
	foreign key (order_user_id) references users(user_id) on update cascade on delete cascade
)

create table cart_line_items(
	clit_id serial,
	clit_reme_id integer,
	clit_redon_id integer,
	clit_qty integer,
	clit_price numeric(15,2),
	clit_sutotal numeric(15,2),
	clit_order_name varchar(30),
	clit_cart_id integer,
	constraint clit_id_pk primary key (clit_id),
	foreign key (clit_cart_id) references carts(cart_id) on update cascade on delete cascade
)



