-- Database: desicart

-- DROP DATABASE desicart;

-- CREATE DATABASE desicart
--     WITH 
--     OWNER = anthaledhu
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'en_US.UTF-8'
--     LC_CTYPE = 'en_US.UTF-8'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1;
	
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
		created_by varchar(100),
		created_on timestamp,
		updated_by varchar(250),
		updated_on timestamp
	);
	
	create table cstore.a_user (
	   user_id serial PRIMARY KEY,
	   username VARCHAR (50) UNIQUE NOT NULL,
	   password VARCHAR (50) NOT NULL,
	   email VARCHAR (355) UNIQUE NOT NULL,
	   created_on TIMESTAMP NOT NULL,
	   last_login TIMESTAMP
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
		store_id integer NOT NULL,
		user_id integer NOT NULL,
		PRIMARY KEY (store_id, user_id),
		CONSTRAINT store_user_user_id_fkey FOREIGN KEY (user_id)
			REFERENCES cstore.a_user(user_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT store_user_store_id_fkey FOREIGN KEY (store_id)
			REFERENCES cstore.store(store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.product (
		product_id serial primary key,
		product_name varchar(250) NOT NULL,
		ptype varchar(200) NOT NULL,
		description varchar,
		price integer NOT NULL,
		icon_url varchar,
		image_url varchar,
		quantity_available integer,
		brand varchar
	);
	
	create table cstore.store_product (
		store_id integer NOT NULL,
		product_id integer NOT NULL,
		PRIMARY KEY (store_id, product_id),
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
		created_on TIMESTAMP NOT NULL,
		order_total float DEFAULT 0 NOT NULL,
		order_status varchar(50)
	);
	
	create table cstore.cust_order (
		cust_id integer NOT NULL,
		order_id integer NOT NULL,
		PRIMARY KEY (cust_id, order_id),
		CONSTRAINT order_cust_cust_id_fkey  FOREIGN KEY (cust_id)
			REFERENCES cstore.customer(cust_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT order_cust_order_id_fkey FOREIGN KEY (order_id)
			REFERENCES cstore.a_order(order_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.order_store (
		order_id integer NOT NULL,
		store_id integer NOT NULL,
		PRIMARY KEY(order_id, store_id),
		CONSTRAINT order_store_order_id_fkey FOREIGN KEY (order_id)
			REFERENCES cstore.a_order(order_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT order_store_store_id_fkey FOREIGN KEY (store_id)
			REFERENCES cstore.store (store_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	
	create table cstore.order_product (
		order_id integer NOT NULL,
		product_id integer NOT NULL,
		PRIMARY KEY (order_id, product_id),
		CONSTRAINT order_product_order_id_fkey FOREIGN KEY (order_id)
			REFERENCES cstore.a_order(order_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT order_product_product_id_fkey FOREIGN KEY (product_id)
			REFERENCES cstore.product(product_id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);
	