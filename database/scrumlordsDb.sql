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
	 --/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	 
	-- PROPERTY ID 9   
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
		'3602 Carrollwood Place Circle', 
		'Apt. 32',
		'Tampa', 
		'FL',
		33624,
		2500, 
		'https://images.craigslist.org/00e0e_choydcnAADgz_0cm07K_1200x900.jpg', 
		'08/01/2022',
		2,
		2,
		1150,
		'We believe elevating where you live is about blending it seamlessly 
		with how you live. We go to great lengths designing amenities and 
		choosing locations that put everything within reach. Property Tours Now Available! We are now welcoming in-person and virtual tours. Please contact us today to schedule your appointment.
		Schedule a Tour Today.',
		
		'At Sabal Palm, our stunning community will provide the perfect backdrop for every lifestyle. 
		In each of our one bedroom, two bedroom, and three bedroom luxury apartments in Tampa, FL 
		and throughout our community, the amazing amenities around every corner will allow residents 
		to find the best place to spend their time. Within our homes, residents will love the 
		stainless steel appliances, spacious walk-in closets, and private patios. Throughout the 
		community at our Tampa apartments for rent, residents can take advantage of the resort-style 
		swimming pool, 24-hour fitness center, and beautiful clubhouse and coffee bar. No matter 
		what residents are looking for, it can be found at our Carrollwood, Tampa apartments..
		
		-Balcony -3rd Floor',
	   TRUE);
	   
	-- PROPERTY ID 10   
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
		'106 Hampton Rd', 
		'Apt. 26',
		'Tampa', 
		'FL',
		33624,
		1850, 
		'https://images.craigslist.org/01212_7MKH84kBBGFz_0g808S_1200x900.jpg', 
		'05/01/2022',
		2,
		1,
		1650,
		'We now book our tour appointments online! Please call or text us  to self-schedule 
		from your phone! Book your appointment online today or anytime 24/7!',
		
		'We are pleased to offer in-person tours, virtual tours and Facetime/Skype tours for 
		your convenience. Temperature checks and face masks required for in-person tours and social distancing enforced.

		Step into luxury and refinement in Clearwater most exceptional boutique-style community. 
		Our gourmet kitchens are finished with the finest touches such as stainless steel appliances 
		and granite countertops. Our sparkling pool, spa and zen garden are sure to evoke a relaxing 
		environment. Want to hit the gym? Check out our fitness center with state-of-the-art equipment. 
		Feel like heading to the beach? We are only 10 minutes away! Come see where luxury living 
		meets your lifestyle.',
	   TRUE);	

	   
	-- PROPERTY ID 11   
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
		'1302 Cooperstown Ct', 
		'Apt. 101',
		'Tampa', 
		'FL',
		33624,
		975, 
		'https://images.craigslist.org/00l0l_8reY6i8gd2Xz_0gw0b1_1200x900.jpg', 
		'05/01/2022',
		1,
		1,
		641,
		'Just north of the hustle and bustle of the city, Palms at Sand Lake is a 
		welcoming community of apartments for rent in Tampa, FL. ',
		
		'The community is just minutes from I-275, University of South Florida, 
		local restaurants, University Mall, and parks. While Palms at Sand Lake 
		offers amenities such as a full fitness center, play area, 24-hour laundry 
		facility, and a sparkling pool, our one or two-bedroom apartments are spacious 
		with open floor plans . Our homes are also pet-friendly and offer 
		inviting water views! We are now leasing for our newly renovated 
		apartments, which includes a stackable washer and dryer in select 
		apartments, black appliances, and faux wood flooring. Stop by today to 
		reserve your home at our Tampa, FL apartments.',
	   TRUE);

	   
	-- PROPERTY ID 12   
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
		'8500 Belcher Road', 
		'Apt. 2A',
		'Tampa', 
		'FL',
		33624,
		1225, 
		'https://images.craigslist.org/00E0E_jV4uqejp3ryz_0bE07K_1200x900.jpg', 
		'05/01/2022',
		2,
		2,
		1000,
		'Come home to our community at Bayou Point! At our apartments near St. 
		Petersburg, FL, we offer one bedroom, two bedroom, and three bedroom 
		floorplans that feature details that enhance every lifestyle.',
		
		'In each home, residents will find black kitchen appliances, spacious 
		walk-in closets, full-sized washers and dryers, and a private patio or 
		balcony to take in some fresh air while enjoying a cup of coffee. The 
		community at our apartments in Pinellas Park also features amazing 
		amenities like lake views and a swimming pool. Residents will love 
		our ideal location because they can easily access the beach and the 
		best shopping and dining at our apartments near Clearwater, FL. Find 
		your new home at Bayou Point Apartments for rent in Pinellas Park. 
		Contact us for more information today!',
	   TRUE);	

	   
	-- PROPERTY ID 13   
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
		'5150 Net Drive', 
		'Apt. 22A',
		'Tampa', 
		'FL',
		33624,
		1000, 
		'https://images.craigslist.org/00r0r_czYO08vAonWz_0cU07g_1200x900.jpg', 
		'05/01/2022',
		1,
		1,
		752,
		'Enjoy living in a newly renovated home at 5 West Apartments! Our one 
		bedroom and two bedroom apartments for rent in Tampa features an 
		unparalleled luxury lifestyle with amazing amenities and an ideal location. ',
		
		'Interiors are spacious enough to accommodate large closets, 9 ft. ceilings, 
		and a private patio or balcony. Elegant details can be found throughout, 
		like customer counters, track lighting, and cordless security monitoring 
		systems. Our apartments in Town ‘N’ Country Tampa, FL give residents exclusive 
		access to a brand new fitness center, a new cyber lounge with high-speed 
		Wi-Fi, and a unique swimming pool with an expansive sundeck overlooking 5 
		West Apartments private lake. Not to mention, we are just a short commute 
		to Downtown, Westshore Business District, and the International Plaza. 
		Everything residents need for comfort and convenience can be found at our 
		Northwest Tampa apartments',
	   TRUE);	 

	   
	-- PROPERTY ID 14   
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
		'5501 110th Avenue', 
		'Apt. 2D',
		'Tampa', 
		'FL',
		33624,
		1950, 
		'https://images.craigslist.org/01111_1SAPfKcBFTLz_0cU07f_1200x900.jpg', 
		'06/01/2022',
		2,
		2,
		1182,
		'Aspire At Gateway offers our residents a place to discover all they need for a life of ease. ',
		
		'With a selection of one bedroom, two bedroom, and three bedroom homes and a 
		stunning community, our Pinellas Park apartments will provide the perfect place 
		to call home. In each of our homes, residents will love the private patios, 
		full-sized washer and dryer, and spacious closets. Throughout the community at our 
		apartments near Clearwater, FL, residents can take advantage of the beautiful swimming pool, 
		fitness center, and outdoor barbecue area.',
	   TRUE);


	   
	-- PROPERTY ID 15   
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
		'2615 North Grady Avenue', 
		'Apt. 4B',
		'Tampa', 
		'FL',
		33624,
		2250, 
		'https://images.craigslist.org/00808_3PFyXht1HbTz_0g8094_1200x900.jpg', 
		'05/18/2022',
		2,
		2,
		1180,
		'We now book our tour appointments online! Please call or text us to 
		self-schedule from your phone! Book your appointment online today or anytime 24/7!',
		
		'We are pleased to offer in-person tours, virtual tours and Facetime/Skype 
		tours for your convenience. Temperature checks and face masks required for 
		in-person tours and social distancing enforced.

		Located in the Westshore Tampa area, Grady Square is a community 
		like no other. You’ll find an abundance of amenities at your doorstep 
		from the state-of-the-art gym, yoga and spin room to the resort-style 
		pool and interactive courtyards! Pampered is a way of life for Grady 
		Square residents. Offering stylish urban lofts, one-, two- and three-bedroom 
		residences, Grady Square is sure to have a place suited to your lifestyle. 
		It’s more than an apartment, it is an experience!',
	   TRUE);

	   
	-- PROPERTY ID 16   
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
		'2615 North Grady Avenue', 
		'Apt. 104',
		'Tampa', 
		'FL',
		33624,
		1750, 
		'https://images.craigslist.org/01010_2lRnuSeI7WLz_0cU08B_1200x900.jpg', 
		'05/01/2022',
		1,
		1,
		630,
		'Searching for great apartment home living in sunny Temple Terrace, ]
		Florida? We have just the place for you. ',
		
		'The Park at Valenza is a unique and inviting community that offers 
		the lifestyle you deserve. Our location allows for easy access to 
		lakes, state parks, shopping, restaurants, and entertainment venues,
		all nearby. The Park at Valenza is your gateway to fun and excitement
		in the beautiful sunshine state.

		We offer a wide variety of floor plans with one, two, and
		three-bedroom apartments for rent. Come discover the lifestyle
		you have been dreaming of.

		From the moment you arrive, you will feel like you’ve come home. 
		Take heart in knowing we are a pet-friendly community, so your 
		four-legged friends are welcome to come along. Our on-call and on-site
		maintenance teams are dedicated to providing quick and excellent
		service when you need it. Come tour our community and see what makes
		The Park at Valenza the best apartment community in Temple Terrace, Florida.',
	   TRUE);	

	   
	-- PROPERTY ID 17   
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
		'3301 Whitney Rd', 
		'Apt. 1',
		'Tampa', 
		'FL',
		33624,
		2650, 
		'https://images.craigslist.org/00C0C_4mderJc8bZIz_09i03i_1200x900.jpg', 
		'06/01/2022',
		3,
		3,
		1890,
		'Call about our specials.  Discover a lifestyle of elegance 
		and tranquility at Whitney Place, the newest townhome community
		in Clearwater, Florida.',
		
		'Call about our specials.  Discover a lifestyle of elegance and 
		tranquility at Whitney Place, the newest townhome community in 
		Clearwater, Florida. Tucked away in a peaceful neighborhood with 
		easy access to all the comforts Clearwater has to offer, you will 
		love calling this serene townhome community home.',
	   TRUE);

	   
	-- PROPERTY ID 18   
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
		'7610 W Waters Ave', 
		'Apt. 321',
		'Tampa', 
		'FL',
		33624,
		1875, 
		'https://images.craigslist.org/00R0R_bPQQD0c5l10z_0bC07K_1200x900.jpg', 
		'06/01/2022',
		2,
		2,
		1000,
		'At WestEnd, our residents will love getting to come home to our 
		beautiful community. With a selection of studio, 1 bedroom, and 2 
		bedroom apartments in Tampa and a community that is filled with 
		amazing amenities, residents can find the best place to call home. ',
		
		'At WestEnd, our residents will love getting to come home to our 
		beautiful community. With a selection of studio, 1 bedroom, and 
		2 bedroom apartments in Tampa and a community that is filled with
		amazing amenities, residents can find the best place to call home.
		Each home includes a modern kitchen with stainless steel appliances 
		and designer cabinetry, walk-in closets, and a private patio. Throughout
		our community, residents can take advantage of the resort-style swimming 
		pool, 24-hour fitness center, and newly designed clubhouse. No matter 
		what our residents are in search of, it can be found at our West Tampa 
		apartments.',
	   TRUE);	

	   
	-- PROPERTY ID 19   
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
		'5501 110th Avenue', 
		'Apt. 112',
		'Tampa', 
		'FL',
		33624,
		2300, 
		'https://images.craigslist.org/00O0O_f6k4VwtI7Zjz_0cU07f_1200x900.jpg', 
		'05/01/2022',
		2,
		2,
		1182,
		'Aspire At Gateway offers our residents a place to discover all 
		they need for a life of ease. With a selection of one bedroom, 
		two bedroom, and three bedroom homes and a stunning community, 
		our Pinellas Park apartments will provide the perfect place to
		call home. ',
		
		'Aspire At Gateway offers our residents a place to discover 
		all they need for a life of ease. With a selection of one bedroom, 
		two bedroom, and three bedroom homes and a stunning community, our 
		Pinellas Park apartments will provide the perfect place to call home. 
		In each of our homes, residents will love the private patios, 
		full-sized washer and dryer, and spacious closets. Throughout
		the community at our apartments near Clearwater, FL, residents
		can take advantage of the beautiful swimming pool, fitness center, 
		and outdoor barbecue area.',
	   TRUE);		   	   
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
		
-- OWNERSHIP ID 5
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		2,
		8
		);
-- OWNERSHIP ID 6
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		4,
		9
		);
		
-- OWNERSHIP ID 7
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		6,
		8
		);
		
-- OWNERSHIP ID 8
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		7,
		9
		);		
		
-- OWNERSHIP ID 9
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		9,
		9
		);	
		
-- OWNERSHIP ID 10
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		10,
		9
		);		
		
-- OWNERSHIP 11
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		11,
		8
		);		
		
-- OWNERSHIP ID 12
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		12,
		8
		);		
		
-- OWNERSHIP ID 13
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		13,
		8
		);		
		
-- OWNERSHIP ID 14
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		14,
		9
		);		
		
-- OWNERSHIP ID 15
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		15,
		9
		);		
		
-- OWNERSHIP ID 16
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		16,
		8
		);		
		
-- OWNERSHIP ID 17
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		17,
		9
		);		
		
-- OWNERSHIP ID 18
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		18,
		9
		);		
		
-- OWNERSHIP ID 19
INSERT INTO ownership (
			property_id,
			landlord
			)
VALUES (
		19,
		9
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
	2,
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
	2,
	'The shrubs need to be trimmed.',
	TRUE,
	true,
	false
);

-- MAINTENANCE TABLE ID 4
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
	2,
	'The porch light is broken',
	TRUE,
	true,
	false
);

-- MAINTENANCE TABLE ID 5
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	new_request,
	assigned,
	complete
)

VALUES (
	3,
	2,
	'The automatic sprinkler does not shut off.',
	FALSE,
	true,
	TRUE
	
);


-- MAINTENANCE TABLE ID 6
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	new_request,
	assigned,
	complete
	
	
)
VALUES (
	2,
	2,
	'The bathroom window is broken.',
	TRUE,
	true,
	FALSE
	
);

-- MAINTENANCE TABLE ID 7
INSERT INTO maintenance(
	ownership_id,
	maint_staff_id,
	description,
	new_request,
	assigned,
	complete
	
	
)
VALUES (
	3,
	2,
	'The tile in the bathroom is cracked and needs to be repalced.',
	FALSE,
	TRUE,
	FALSE
	
);

-- MAINTENANCE TABLE ID 8
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	4,
	'The lights in the living room flicker when they first turn on.',
	FALSE,
	True,
	false,
	2
);

-- MAINTENANCE TABLE ID 9
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	2,
	'The hot water heater is leaking and the water does not get very hot.',
	FALSE,
	True,
	FALSE,
	2
);

-- MAINTENANCE TABLE ID 10
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	1,
	'The yard requires a spring clean-up.  Leaves raked, edged, and new grass seed.',
	TRUE,
	TRUE,
	FALSE,
	2
);

-- MAINTENANCE TABLE ID 11
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	2,
	'There is a leak in the roof.  It is leaking into the living room and onto my TV!',
	FALSE,
	TRUE,
	FALSE,
	2
);

-- MAINTENANCE TABLE ID 12
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	1,
	'The pool is too cold.  The pool heater needs to be adjusted.',
	FALSE,
	TRUE,
	TRUE,
	2
);

-- MAINTENANCE TABLE ID 13
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	4,
	'The two front window screens are ripped and need to be repalced.',
	FALSE,
	TRUE,
	FALSE,
	2
);

-- MAINTENANCE TABLE ID 14
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	4,
	'The bathroom door does not close properly.',
	TRUE,
	TRUE,
	FALSE,
	2
);

-- MAINTENANCE TABLE ID 15
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	1,
	'The outlet in the kitchen island is not working.',
	FALSE,
	TRUE,
	TRUE,
	2
);

-- MAINTENANCE TABLE ID 16
INSERT INTO maintenance(
	ownership_id,
	description,
	new_request,
	assigned,
	complete,
	maint_staff_id
	
)
VALUES (
	2,
	'The washing machine does not turn on.',
	True,
	true,
	False,
	2
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
-- ACCOUNT_ID 1 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/25
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

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/26
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/27
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/28
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/29
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/30
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/31
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
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/32
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
	'Payment',
	1200,
	0
);
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/33
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

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 1/34
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

--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- ACCOUNT_ID 4 PAYMENT HISTORY
-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/35
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

-- ACCOUNT_ID/ACCOUNT_HISTORY ACCOUNT_HISTORY_ID 4/36
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
	'12/1/2021',
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
	'12/1/2021',
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
	'1/1/2022',
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
	'1/1/2022',
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
	'2/1/2022',
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
	'3/1/2022',
	'Charge - Rent',
	4325,
	8650
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
	'4/1/2022',
	'Charge - Rent',
	4325,
	12975
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
