-- If not created yet, create a database called scrumlords
ROLLBACK;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS users, apartments, ownership, account, account_history, maint_staff, maintenance, notification;

DROP SEQUENCE IF EXISTS seq_user_id;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;


CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) UNIQUE NOT NULL,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

CREATE TABLE apartments (
	property_id serial,
	landlord int NOT NULL,
	address_line_1 varchar(150) NOT NULL,
	address_line_2 varchar(150),
	city varchar(250) NOT NULL,
	state varchar(250) NOT NULL,
	zip decimal NOT NULL,
	price decimal NOT NULL,
	picture text,
	available date NOT NULL,
	num_bedrooms decimal,
	num_bathrooms decimal,
	square_feet int,
	short_description text,
	long_description text,
	available_for_rent boolean,
	
	CONSTRAINT PK_apartments PRIMARY KEY (property_id)
);

-- Maybe additional fields for timestamp and user input
-- Maybe foriegn key of user_id (linker table?)

-- Might have to limit roles to specific values

CREATE TABLE ownership (
	ownership_id serial,
	property_id int NOT NULL,
	landlord int NOT NULL,
	renter int,

	CONSTRAINT PK_ownership PRIMARY KEY (ownership_id),
	CONSTRAINT FK1_ownership_users FOREIGN KEY (landlord) REFERENCES users(user_id),
	CONSTRAINT FK2_ownership_users FOREIGN KEY (renter) REFERENCES users(user_id),
	CONSTRAINT FK3_ownership_apartments FOREIGN KEY (property_id) REFERENCES apartments(property_id)
);

CREATE TABLE account (
	account_id serial,
	ownership_id int not null,
	balance_due decimal,
	monthly_rent_amt decimal,
	past_due boolean,
		
	CONSTRAINT PK_account PRIMARY KEY (account_id),
	CONSTRAINT FK_account_ownership FOREIGN KEY (ownership_id) REFERENCES ownership(ownership_id)
);

CREATE TABLE account_history (
	account_history_id serial,
	account_id int not null,
	date DATE not null,
	memo varchar(250) not null,
	amount decimal not null,
	balance decimal not null,
		
	CONSTRAINT PK_account_history PRIMARY KEY (account_history_id),
	CONSTRAINT FK_account_history_account FOREIGN KEY (account_id) REFERENCES account(account_id)
);

CREATE TABLE maint_staff (
	maint_staff_id SERIAL,
	staff_user_id int NOT NULL,
	staff_name varchar(50) NOT NULL,
	service_dept varchar(30) NOT NULL,
		
	CONSTRAINT PK_maint_staff PRIMARY KEY (maint_staff_id),
	CONSTRAINT FK1_maint_staff_users FOREIGN KEY (staff_user_id) REFERENCES users(user_id),
	CONSTRAINT FK2_maint_staff_users FOREIGN KEY (staff_name) REFERENCES users(username)
);

CREATE TABLE maintenance (
	maintenance_id SERIAL,
	ownership_id int NOT NULL,
	maint_staff_id int,
	description text NOT NULL,
	complete boolean,
	assigned boolean,
	new_request boolean,
	date_submitted DATE NOT NULL DEFAULT now(),
	
	CONSTRAINT PK_maintenance PRIMARY KEY (maintenance_id),
	CONSTRAINT FK1_maintenance_ownership FOREIGN KEY (ownership_id) REFERENCES ownership(ownership_id),
	CONSTRAINT FK2_maintenance_maint_staff FOREIGN KEY (maint_staff_id) REFERENCES maint_staff(maint_staff_id)
);

CREATE TABLE notification (
	notification_id serial,
	user_id int not null,
	message varchar(200) not null,
	read boolean,
		
	CONSTRAINT PK_notification PRIMARY KEY (notification_id),
	CONSTRAINT FK_notification_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);


------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BASE USERS
INSERT INTO users (username,password_hash,role) VALUES ('user','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER');  -- UID 1
INSERT INTO users (username,password_hash,role) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN');-- UID 2

-- MAINTENANCE STAFF USERS
INSERT INTO users (username,password_hash,role) VALUES ('Mary Chiller','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','STAFF'); -- UID 3
INSERT INTO users (username,password_hash,role) VALUES ('Sam Carpenter','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','STAFF'); -- UID 4
INSERT INTO users (username,password_hash,role) VALUES ('Sally Watts','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','STAFF'); -- UID 5
INSERT INTO users (username,password_hash,role) VALUES ('Tom Mower','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','STAFF'); -- UID 6
INSERT INTO users (username,password_hash,role) VALUES ('John Snow','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','STAFF'); -- UID 7

-- LANDLORD USERS
INSERT INTO users (username,password_hash,role) VALUES ('Fred Mertz','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','LANDLORD'); -- UID 8
INSERT INTO users (username,password_hash,role) VALUES ('Mr. Shickadance','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','LANDLORD'); -- UID 9

-- RENTER USERS
INSERT INTO users (username,password_hash,role) VALUES ('Frank Goodyear','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','RENTER'); -- UID 10
INSERT INTO users (username,password_hash,role) VALUES ('Annie Singleton','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','RENTER'); -- UID 11
INSERT INTO users (username,password_hash,role) VALUES ('Tony Stark','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','RENTER'); -- UID 12
INSERT INTO users (username,password_hash,role) VALUES ('Jake Olsen','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','RENTER'); -- UID 13

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PROPERTY ID 1
INSERT INTO apartments (
			landlord,
			address_line_1,
			address_line_2,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (8,
		'1154 Jackson Rd.', 
		'Apt. 2',
		'Clearwater', 
		'FL',
		33755,
		1200, 
		'https://images.craigslist.org/00q0q_d84kdcQiB1Bz_0bC07K_1200x900.jpg', 
		'08/01/2022',
		3,
		2,
		1500,
		'Charming North-End newly constructed duplex unit.',
		'Located on quiet dead-end street\, 
		centrally located to downtown\, greenbelt, and foothills. Application submittal 
		required prior to scheduling walk-through.',
	   FALSE);
		
-- PROPERTY ID 2
INSERT INTO apartments (
			landlord,
			address_line_1,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (8,
		'222 N Betty Ln.', 
		'Clearwater', 
		'FL',
		33755,
		3200, 
		'https://images.craigslist.org/01414_5ZWT1ZU7cexz_0cU07g_1200x900.jpg', 
		'12/1/2022',
		3,
		2,
		1800,
		'Available December 1st, 2021 No Pets! 3 bedroom apartment 2nd floor 
		including utilities & high speed internet available ! 1 GB/second ! 
		Parking on the drive way for max 2 cars!',
		
		'This Cute & Cozy Dont Overlook This Hidden Gem!! Close Proximity 
		To Smith Haven Mall, Suffolk Community College, Stony Brook 
		Hospital/University & Route 25A. THIS WILL NOT LAST AGAIN!! Extensive 
		background check and credit references! No pets no exceptions! 
		Required 1 month broker fees 1 month security, paystubs required!! 
		1 year lease $6,000 to move in! Call to schedule a showing',
	   TRUE);

-- PROPERTY ID 3
INSERT INTO apartments (
			landlord,
			address_line_1,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (8,
		'318 N Prescott Ave', 
		'Clearwater', 
		'FL',
		33755,
		1700, 
		'https://images.craigslist.org/00m0m_dRG0vdPXOR4z_0bC07K_1200x900.jpg', 
		'06/01/2022',
		1,
		1,
		900,
		'1 bedroom apartment on second floor with separate living room and 
		eat in kitchen with walk in pantry, Private rear entry and driveway parking.',
		
		'No pets and no smoking. $1700 includes all utilities. Additional fee for AC in 
		summer months. Wifi and cable is the responsibility of the tenant. Available 
		June 5th. 1 month security, 1 month broker fee and first months rent due upfront. 
		Email agent to schedule a showing. HomeSmart Premier Living Realty',
	   FALSE);
		
-- PROPERTY ID 4
INSERT INTO apartments (
			landlord,
			address_line_1,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (8,
		'1577 Walnut St', 
		'Clearwater', 
		'FL',
		33755,
		1200, 
		'https://images.craigslist.org/00h0h_lFbX1WrrKnuz_0jm0cT_1200x900.jpg', 
		'08/01/2022',
		2,
		1,
		2600,
		'Georgeous ,spotless,2nd floor 2 br apartment, just paint it, windows 
		all around with loots of sunlight, washer and dryer.',
		
		'Safe and quiet neiborhoot, close to Adelphi and Hofstra univercities,
		close to Roosvelt field mall and Nassau courts. Close to LIJ ,Winthrop 
		hospitals. You pay 50% of the utilities. Available now. NO SMOKING,NO PETS.Please call Lisa',
	   TRUE);

-- PROPERTY ID 5
INSERT INTO apartments (
			landlord,
			address_line_1,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (9,
		'1453 Springdale St', 
		'Clearwater', 
		'FL',
		33755,
		1350, 
		'https://images.craigslist.org/00S0S_kp2M8tSbyMkz_0bC07K_1200x900.jpg', 
		'05/15/2022',
		1,
		1,
		700,
		'Fairfield at Smithtown Apartment Rental Lovely Ground Level Studio, One Bath Unit. ',
		
		'Rent Includes Heat and Hot Water. Newly Renovated Apartment Rental. Close to Town and 
		Smithtown Train Station! Nestled in a Quaint Residential setting with a short Distance 
		to many Shops, Great Restaurants! Current Special $1000 Security Deposit with Approved Credit. Fairfield 
		at Smithtown offers the Standard of Excellence and Service! This is a cozy community nestled 
		in a park like setting with gorgeous, comfortable modern interiors. Locally we are a short drive 
		to shopping and very close distance to Smithtown historic quaint Village and the Smithtown train station! 
		Pricing may include current special, is subject to change without notice restrictions apply—call for 
		details. All layouts, dimensions and interior finishes are approximate and for display. Call/email/visit with 
		Leasing Agent for full unit details. Equal Housing Opportunity owner/management.',
	   FALSE);
		
-- PROPERTY ID 6
INSERT INTO apartments (
			landlord,
			address_line_1,
			address_line_2,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (9,
		'1837 Venetian Point Dr', 
		'Apt. 2',
		'Clearwater', 
		'FL',
		33755,
		2200, 
		'https://images.craigslist.org/00202_6VqN40l9CAnz_0bC07K_1200x900.jpg', 
		'06/01/2022',
		1,
		1,
		1000,
		'Located minutes from Smith Haven Mall, movies, shops, restaurants, 
		and Stony Brook university and Hospital. Our convenient location puts 
		you close to all major high way and LIRR. The BUS station to Stony Brook 
		Hospital and university is nearby.',
		
		'Nice Neighborhood with Security area. Utilities Included No Smoking/No Pets private 
		driveway, separate entrance and more! This is located down the blocks from Stony 
		Brook Hospital and Stony Brook University . Perfect for GRAD Student or Medical 
		Residents. Not good for big family.
		
		Includes all utilities/WiFi. We are looking for long term tenants who can 
		appreciate a place like this and are willing to treat it with care. Serious 
		inquiries only, Pictures on request. You must be able to verify your employment, 
		income and have current references. Subject to credit check.
		
		1 Year lease minimum - First Month Rent . 1 Month Security Deposit at lease 
		signing. Subject to credit check.
		
		THERE ARE NO BROKER FEES - NO SMOKING - NO PETS - SERIOUS INQUIRIES ONLY',
	   	TRUE);

-- PROPERTY ID 7
INSERT INTO apartments (
			landlord,
			address_line_1,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (9,
		'1249 Eldridge St', 
		'Clearwater', 
		'FL',
		33755,
		2750, 
		'https://images.craigslist.org/00U0U_4O7L8Sqe7U3z_0cU07g_600x450.jpg', 
		'07/01/2022',
		4,
		2,
		1288,
		'A very unique and special property. Located in the mid ridges of 
		Stamford and is situated on .86 of acre. This property was home to 
		a well renowned Excavating company.',
		
		'The yard is still active. Grandfather Contractor yard all began 
		in 1946 and the residence was rebuilt in 1977. The trucks were station 
		on the property, with a two Bay garage with office it can hold two ten 
		wheelers. The home is a cape colonial and consists of 4 bedrooms and 3 
		full baths and comes with a guest suite or it could be used for a work 
		office space. The property is a perfect fit for a contractor that is looking 
		to station all their commercial vehicles. Zoning approval is under review. 
		Submit all offers and addendum of vehicles and its usage. 
		
		This property can also be sub-divided. If contractors yard is not suitable 
		for the interested buyer. Call for more details. Provide your own due diligence. 
		Zoning approval will still be required.',
	   TRUE);
		
-- PROPERTY ID 8
INSERT INTO apartments (
			landlord,
			address_line_1,
			address_line_2,
			city,
			state,
			zip,
			price,
			picture,
			available,
			num_bedrooms,
			num_bathrooms,
			square_feet,
			short_description,
			long_description,
			available_for_rent)
VALUES (9,
		'50 Coe Rd', 
		'Apt. 2',
		'Belleair', 
		'FL',
		33756,
		4325, 
		'https://images.craigslist.org/00000_ghTSHobkz8oz_0jm0cU_1200x900.jpg', 
		'09/01/2022',
		3,
		2,
		1248,
		'We believe elevating where you live is about blending it seamlessly 
		with how you live. We go to great lengths designing amenities and 
		choosing locations that put everything within reach. ',
		
		'Where you live, is where you come alive. In an area flourishing with 
		convenience, entertainment and possibility, Avalon offers luxury 
		Huntington Station apartments for rent. Walking into our refreshing 
		smoke-free community, you will find thoughtfully designed one-, two- and 
		three- bedroom apartment homes. Imagine entertaining in your contemporary 
		kitchen with cherry or espresso cabinetry, tile backsplashes, and stainless 
		steel appliances. Select homes also offer granite or quartz kitchen and 
		bath countertops. Picture living your life effortlessly, with 
		amenities that include a state-of-the-art fitness center, swimming pool, 
		and easy access to the LIRR Huntington Station. This is not just 
		apartment living. This is living up.
		
		-Balcony -3rd Floor',
	   FALSE);
----------------------------------------------------------------------------------------
--  NOTIFICATOIN TABLE
-- NOTIFICAION ID 1
INSERT INTO notification (
			user_id,
			message,
			read
			)
VALUES (
		10,
		'Your rent is past due',
		FALSE
		);
		
-- NOTIFICAION ID 2
INSERT INTO notification (
			user_id,
			message,
			read
			)
VALUES (
		5,
		'You have a new maintenance assignment',
		TRUE
		);
----------------------------------------------------------------------
--  MAINT_STAFF TABLE
-- MAINT_STAFF ID 1
INSERT INTO maint_staff (
		staff_user_id,
		staff_name,
		service_dept
		)
VALUES (
		3,
		'Mary Chiller',
		'HVAC'
		);
-- MAINT_STAFF ID 2
INSERT INTO maint_staff (
		staff_user_id,
		staff_name,
		service_dept
		)
VALUES (
		4,
		'Sam Carpenter',
		'Carpentry'
		);
-- MAINT_STAFF ID 3		
INSERT INTO maint_staff (
		staff_user_id,
		staff_name,
		service_dept
		)
VALUES (
		5,
		'Sally Watts',
		'Electrician'
		);

-- MAINT_STAFF ID 4		
INSERT INTO maint_staff (
		staff_user_id,
		staff_name,
		service_dept
		)
VALUES (
		6,
		'Tom Mower',
		'Landscaping'
		);
-- MAINT_STAFF ID 5		
INSERT INTO maint_staff (
		staff_user_id,
		staff_name,
		service_dept
		)
VALUES (
		7,
		'John Snow',
		'Security'
		);
-----------------------------------------------------
--  OWNERSHIP TABLE
-- OWNERSHIP ID 1
INSERT INTO ownership (
			property_id,
			landlord,
			renter
			)
VALUES (
		1,
		8,
		10
		);
-- OWNERSHIP ID 2
INSERT INTO ownership (
			property_id,
			landlord,
			renter
			)
VALUES (
		5,
		9,
		11
		);
-- OWNERSHIP ID 3
INSERT INTO ownership (
			property_id,
			landlord,
			renter
			)
VALUES (
		3,
		8,
		12
		);
-- OWNERSHIP ID 4
INSERT INTO ownership (
			property_id,
			landlord,
			renter
			)
VALUES (
		8,
		9,
		13
		);
		
------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE TABLE
-- MAINTENANCE TABLE ID 1
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	assigned,
	new_request
)
VALUES (
	1,
	1,
	'The air conditioning system does not get cold in the garage.',
	TRUE,
	FALSE
);
-- MAINTENANCE TABLE ID 2
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	assigned,
	new_request
)
VALUES (
	2,
	2,
	'The front door does not close properly.',
	TRUE,
	FALSE
);

-- MAINTENANCE TABLE ID 3
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	assigned,
	new_request,
	complete
)
VALUES (
	3,
	4,
	'The shrubs need to be trimmed.',
	TRUE,
	FALSE,
	TRUE
);

-- MAINTENANCE TABLE ID 4
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request
)
VALUES (
	3,
	'The porch light is broken',
	TRUE
);

-- MAINTENANCE TABLE ID 5
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	3,
	'The automatic sprinkler does not shut off.',
	FALSE,
	FALSE,
	TRUE,
	4
);

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT TABLE
-- ACCOUNT TABLE ID 1
INSERT INTO account(
	ownership_id,
	balance_due,
	monthly_rent_amt,
	past_due
)
VALUES (
	1,
	2400,
	1200,
	TRUE	
);

-- ACCOUNT TABLE ID 2
INSERT INTO account(
	ownership_id,
	balance_due,
	monthly_rent_amt
)
VALUES (
	2,
	1350,
	1350	
);

-- ACCOUNT TABLE ID 3
INSERT INTO account(
	ownership_id,
	balance_due,
	monthly_rent_amt,
	past_due
)
VALUES (
	3,
	1700,
	1700,
	FALSE	
);

-- ACCOUNT TABLE ID 4
INSERT INTO account(
	ownership_id,
	balance_due,
	monthly_rent_amt,
	past_due
)
VALUES (
	4,
	12975,
	4325,
	TRUE	
);

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT_HISTORY TABLE
-- ACCOUNT_ID 3 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/1
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'11/1/2021',
	'Charge - Rent',
	1700,
	1700
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/2
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'11/1/2021',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/3
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'12/1/2021',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/4
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'12/1/2021',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/5
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'1/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/6
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'1/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/7
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'2/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/8
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'2/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/9
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'3/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/10
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'3/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/11
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'4/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/12
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'4/1/2022',
	'Payment',
	1700,
	0
);

--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ACCOUNT_ID 2 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/13
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'11/1/2021',
	'Charge - Rent',
	1350,
	1350
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/14
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'11/1/2021',
	'Payment',
	1350,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/15
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'12/1/2021',
	'Charge - Rent',
	1350,
	1350
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/16
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'12/1/2021',
	'Payment',
	1350,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/17
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'1/1/2022',
	'Charge - Rent',
	1350,
	1350
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/18
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'1/1/2022',
	'Payment',
	1350,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/19
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'2/1/2022',
	'Charge - Rent',
	1350,
	1350
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/20
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'2/1/2022',
	'Payment',
	1350,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/21
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'3/1/2022',
	'Charge - Rent',
	1350,
	1350
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/22
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'3/1/2022',
	'Payment',
	1350,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/23
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'4/1/2022',
	'Charge - Rent',
	1350,
	1350
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 2/24
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'4/1/2022',
	'Payment',
	1350,
	0
);


--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ACCOUNT_ID 3 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/25
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'11/1/2021',
	'Charge - Rent',
	1700,
	1700
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/26
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'11/1/2021',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/27
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'12/1/2021',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/28
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'12/1/2021',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/29
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'1/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/30
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'1/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/31
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'2/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/32
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'2/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/33
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'3/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/34
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'3/1/2022',
	'Payment',
	1700,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/35
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'4/1/2022',
	'Charge - Rent',
	1700,
	1700
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 3/36
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	3,
	'4/1/2022',
	'Payment',
	1700,
	0
);


--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ACCOUNT_ID 4 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/37
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'11/1/2021',
	'Charge - Rent',
	4325,
	4325
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/38
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'11/1/2021',
	'Payment',
	4325,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/39
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'12/1/2021',
	'Charge - Rent',
	4325,
	4325
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/40
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'12/1/2021',
	'Payment',
	4325,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/41
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'1/1/2022',
	'Charge - Rent',
	4325,
	4325
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/42
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'1/1/2022',
	'Payment',
	4325,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/43
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	4,
	'2/1/2022',
	'Charge - Rent',
	4325,
	4325
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/44
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'3/1/2022',
	'Charge - Rent',
	4325,
	8650
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/45
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	2,
	'4/1/2022',
	'Charge - Rent',
	4325,
	12975
);



--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ACCOUNT_ID 1 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/46
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'11/1/2021',
	'Charge - Rent',
	1200,
	1200
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/47
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'11/1/2021',
	'Payment',
	1200,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/48
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'12/1/2021',
	'Charge - Rent',
	1200,
	1200
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/49
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'12/1/2021',
	'Payment',
	1200,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/50
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'1/1/2022',
	'Charge - Rent',
	1200,
	1200
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/51
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'1/1/2022',
	'Payment',
	1200,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/52
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'2/1/2022',
	'Charge - Rent',
	1200,
	1200
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/53
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'1/1/2022',
	'Payment',
	1200,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/54
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'3/1/2022',
	'Charge - Rent',
	1200,
	1200
);

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/55
INSERT INTO account_history(
	account_id,
	date,
	memo,
	amount,
	balance
)
VALUES (
	1,
	'4/1/2022',
	'Charge - Rent',
	1200,
	2400
);


----------------------------------------------------------------------------------
--- USER SETUP (Do Not Modify)
DROP USER IF EXISTS final_capstone_owner;
DROP USER IF EXISTS final_capstone_appuser;

DROP USER IF EXISTS final_capstone_owner;
DROP USER IF EXISTS final_capstone_appuser;

CREATE USER final_capstone_owner
WITH PASSWORD 'finalcapstone';

GRANT ALL
ON ALL TABLES IN SCHEMA public
TO final_capstone_owner;

GRANT ALL
ON ALL SEQUENCES IN SCHEMA public
TO final_capstone_owner;

CREATE USER final_capstone_appuser
WITH PASSWORD 'finalcapstone';

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
TO final_capstone_appuser;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO final_capstone_appuser;

COMMIT TRANSACTION;
