-- Database: desicart

-- DROP DATABASE desicart;

CREATE DATABASE desicart
    WITH 
    OWNER = anthaledhu
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
	CREATE SCHEMA IF NOT EXISTS cstore;
	
	create table cstore.store (
		store_id serial primary key,
		store_name varchar(250),
		short_name varchar(250),
		type varchar(100),
		phone varchar(15),
		address1 varchar(250),
		address2 varchar(250),
		city varchar(200),
		store_state varchar(200),
		zip varchar(10),
		created_by varchar(250),
		created_on timestamp,
		updated_by varchar(250),
		updated_on timestamp,
		status varchar(50)
	);
	
	create table cstore.a_user (
	   user_id serial PRIMARY KEY,
	   username VARCHAR (50) UNIQUE NOT NULL,
	   password VARCHAR (50) NOT NULL,
	   email VARCHAR (355) UNIQUE NOT NULL,
	   created_on TIMESTAMP NOT NULL,
	   last_login TIMESTAMP,
	   status VARCHAR(50)
	);
	
	CREATE TABLE cstore.a_role (
	   role_id serial PRIMARY KEY,
	   role_name VARCHAR (255) UNIQUE NOT NULL
	);
	
	CREATE TABLE cstore.user_role (
	  user_id integer NOT NULL,
	  role_id integer NOT NULL,
	  grant_date timestamp without time zone,
	  PRIMARY KEY (user_id, role_id),
	  CONSTRAINT account_role_role_id_fkey FOREIGN KEY (role_id)
		  REFERENCES cstore.a_role (role_id) MATCH SIMPLE
		  ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT account_role_user_id_fkey FOREIGN KEY (user_id)
		  REFERENCES cstore.a_user (user_id) MATCH SIMPLE
		  ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.store_user(
		store_user_id serial PRIMARY KEY,
		store_id integer NOT NULL,
		user_id integer NOT NULL,
		role_id integer NOT NULL,
		grant_date TIMESTAMP NOT NULL,
		department VARCHAR(100),
		status VARCHAR(50),
		CONSTRAINT store_user_user_id_fkey FOREIGN KEY (user_id)
			REFERENCES cstore.a_user(user_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT store_user_store_id_fkey FOREIGN KEY (store_id)
			REFERENCES cstore.store(store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT store_user_role_id_fkey FOREIGN KEY (role_id)
			REFERENCES cstore.a_role(role_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.product (
		product_id serial primary key,
		product_name varchar(250) NOT NULL,
		ptype varchar(200) NOT NULL,
		description varchar,
		price numeric,
		icon_url varchar,
		image_url varchar,
		quantity_available integer,
		brand varchar
	);
	
	create table cstore.store_product (
		store_product_id  serial PRIMARY KEY,
		store_id integer NOT NULL,
		product_id integer NOT NULL,
		quantity_available integer,
		status VARCHAR(50),
		created_by varchar(250),
		price numeric,
		created_on timestamp,
		updated_by varchar(250),
		updated_on timestamp,
		CONSTRAINT store_product_product_id_fkey FOREIGN KEY (product_id)
			REFERENCES cstore.product(product_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT store_product_store_id_fkey FOREIGN KEY (store_id)
			REFERENCES cstore.store(store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.customer (
		cust_id serial primary key,
		cust_uname VARCHAR (50) UNIQUE NOT NULL,
	    cust_pwd VARCHAR (50) NOT NULL,
	    cust_email VARCHAR (355) UNIQUE NOT NULL,
	    created_on TIMESTAMP NOT NULL,
	    last_login TIMESTAMP
	);
	
	create table cstore.a_order (
		order_id serial primary key,
		store_id integer NOT NULL,
		cust_id integer NOT NULL,
		order_created_date TIMESTAMP NOT NULL,
		order_status_updated_date TIMESTAMP NOT NULL,
		order_total numeric,
		order_status varchar(50),
		cust_notes VARCHAR(250),
		CONSTRAINT order_cust_cust_id_fkey  FOREIGN KEY (cust_id)
			REFERENCES cstore.customer(cust_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT order_store_id_fkey  FOREIGN KEY (store_id)
			REFERENCES cstore.store(store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);

	
	create table cstore.order_items (
		order_id integer NOT NULL,
		store_product_id integer NOT NULL,
		quantity integer DEFAULT 0,
		item_price numeric,
		created_on  TIMESTAMP,
		PRIMARY KEY (order_id, store_product_id),
		CONSTRAINT order_store_product_stp_id_fkey  FOREIGN KEY (store_product_id)
			REFERENCES cstore.store_product(store_product_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT order_store_product_order_id_fkey FOREIGN KEY (order_id)
			REFERENCES cstore.a_order(order_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	


	create table cstore.store_cart (
		cart_id serial primary key,
		cust_id integer NOT NULL,
		store_id integer NOT NULL,
		created_on TIMESTAMP,
		total numeric,
		status VARCHAR(50),
		CONSTRAINT store_cart_user_id_fkey FOREIGN KEY (cust_id)
			REFERENCES cstore.customer(cust_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT store_cart_store_id_fkey FOREIGN KEY (store_id)
			REFERENCES cstore.store(store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);

	create table cstore.cart_items (
		cart_id integer not null,
		store_product_id integer not null,
		quantity integer DEFAULT 0,
		created_on timestamp,
		item_price numeric,
		constraint cart_items_cart_id_fkey foreign key (cart_id)
			REFERENCES cstore.store_cart(cart_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		constraint cart_items_store_product_id_fkey foreign key (store_product_id)
			REFERENCES cstore.store_product(store_product_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.payment_type (
		pay_type_id serial primary key,
		vendor_name varchar,
		vendor_key varchar,
		vendor_id varchar,
		status varchar(50)
	);


	create table cstore.customer_payment (
		payment_id serial primary key,
		vendor_txn_id varchar,
		pay_intent_id varchar,
		pay_type_id integer not null,
		order_id integer not null,
		amount numeric,
		status varchar,
		constraint customer_payment_pay_type_id_fkey foreign key (pay_type_id)
			REFERENCES cstore.payment_type(pay_type_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);

	