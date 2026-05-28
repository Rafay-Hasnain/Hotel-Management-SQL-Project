create database Hotel_Management_Project;
go
use Hotel_Management_Project;
go

-- Hotels

create table Hotels 
	
	(
		HotelID int identity primary key,
		HotelName varchar(200) not null,
		BrandName varchar(200) null,    
		HeadOfficeCity varchar(100) null,
		HeadOfficeCountry varchar(100) null,
		MainPhone varchar(50) null,
		MainEmail varchar(200) null,
		Website varchar(200) null
	);

go

-- Hotel Branches 

create table HotelBranches 
	
	(
		BranchID int identity primary key,
		HotelID  int not null,
		BranchName varchar(200) not null,    
		City varchar(100) not null,
		Country varchar(100) not null,
		AddressLine varchar(250) null,
		PostalCode varchar(20)  null,
		Phone varchar(50)  null,
		Email varchar(200) null,
		NumRooms int null,                 
		foreign key (HotelID) references Hotels(HotelID)
	);

go

-- Guests

create table Guests 
	
	(
		GuestID int identity primary key,
		FirstName varchar(100) not null,
		LastName varchar(100) not null,
		Email varchar(200),
		Phone varchar(50)
	);

go

-- Room Types

create table RoomTypes 
	
	(
		TypeID int identity primary key,
		TypeName varchar(100) not null,
		BaseRate decimal(10,2) not null,
		Capacity  int not null
	);

go

-- Room Status

create table RoomStatus	
	(
		StatusID int identity primary key,
		StatusName varchar(50)
	);

go

-- Rooms

create table Rooms 
	
	(
    RoomID int identity primary key,
    BranchID int not null,
    RoomNumber varchar(20) not null,
    FloorNumber int not null, 
    TypeID int not null,
    IsPerfectView bit not null default 0,
    StatusID int not null default 1, 
    foreign key (BranchID) references HotelBranches(BranchID),
    foreign key (TypeID) references RoomTypes(TypeID),
    foreign key (StatusID) references RoomStatus(StatusID)
	);

go

-- Reservation

create table Reservations 
	(
		ReservationID int identity(1,1) primary key,
		GuestID int not null,
		RoomID int not null,
		BranchID int not null,  
		CheckIn DATE not null,
		NumGuests int not null,
		Rate decimal(10,2) not null,
		foreign key (GuestID) references Guests(GuestID),
		foreign key (RoomID) references Rooms(RoomID),
		foreign key (BranchID) references HotelBranches(BranchID)
	);

go

-- Facility Type

create table FacilityType 
	(
		FacilityTypeID int identity(1,1) primary key,
		FacilityName varchar(100) not null,   
		Descriptions varchar(300) null       
			);

go

-- Facility usage

create table GuestFacilityUsage 
	
	(
		UsageID int identity(1,1) Primary key,
		GuestID int not null,            
		FacilityTypeID int not null,                  
		Quantity int null,              
		ChargeAmount decimal(10,2) null,     
		Notes varchar(300) null,    
		foreign key (FacilityTypeID) references FacilityType(FacilityTypeID),
		foreign key (GuestID)  references Guests(GuestID)
	);

go


-- Employees

create table Employees 
	
	(
		EmployeeID int identity Primary key,
		BranchID int not null,
		FirstName varchar(100) not null,
		LastName varchar(100) not null,
		Email varchar(200),
		Phone varchar(50),
		foreign key (BranchID) references HotelBranches(BranchID)
	);

go

-- Invoices 

create table Invoices 
	
	(
		InvoiceID int identity primary key,
		ReservationID int not null,
		Subtotal decimal(10,2) not null,
		Taxes decimal(10,2) not null,
		Discounts decimal(10,2) not null,
		Total decimal(10,2) not null,
		foreign key (ReservationID) references Reservations(ReservationID)
	);

go

-- Payments 

create table Payments 

	(
		PaymentID int identity primary key,
		InvoiceID int not null,
		PaymentType int not null, -- e.g., 1 = Cash, 2 = Card, 3 = Online
		PaidAt datetime not null default getdate(),
		foreign key (InvoiceID) references Invoices(InvoiceID)
	);

go

-- Services 

create table Services 
	
	(
		ServiceID int identity primary key,
		ServiceName varchar(150) not null
	);

go

-- Service Staff

CREATE TABLE ServiceStaff (
    EmployeeID INT PRIMARY KEY,            -- Same ID as Employees
    Department VARCHAR(100) NOT NULL,      -- e.g. Housekeeping, Room Service
    ShiftTime VARCHAR(50),                 -- Morning / Evening / Night
    IsOnDuty BIT DEFAULT 1,                -- 1 = Active, 0 = Off-duty
    ExperienceYears INT NULL,              -- Optional but useful

    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
	);

go

-- Service Orders 

create table ServiceOrders 

	(
		ServiceOrderID int identity primary key,
		EmployeeID int not null,
		ReservationID int null,
		ServiceID int not null,
		foreign key (ReservationID) references Reservations(ReservationID),
		foreign key (ServiceID) references Services(ServiceID),
		foreign key (EmployeeID) references ServiceStaff(EmployeeID)
	);

go

-- Data Insertion

--Hotel insertion 6 Hotels

insert into Hotels (HotelName, BrandName, HeadOfficeCity, HeadOfficeCountry, MainPhone, MainEmail, Website) values

	('Serena Hotel', 'Serena Group', 'Islamabad', 'Pakistan', '+92-51-111-133-133', 'info@serenahotels.com', 'https://www.serenahotels.com'),
	('Pearl Continental Hotel', 'Hashoo Group', 'Islamabad', 'Pakistan', '+92-51-111-505-505', 'info@pchotels.com', 'https://www.pchotels.com'),
	('Ramada Hotel', 'Wyndham Hotels', 'Karachi', 'Pakistan', '+92-21-111-660-660', 'info@ramada.com.pk', 'https://www.ramada.com'),
	('Marriott Hotel', 'Marriott International', 'Islamabad', 'Pakistan', '+92-51-111-223-344', 'info@marriott.com', 'https://www.marriott.com'),
	('Nishat Hotel', 'Nishat Group', 'Lahore', 'Pakistan', '+92-42-111-646-835', 'info@nishathotels.com', 'https://www.thenishathotel.com'),
	('Avari Hotel', 'Avari Group', 'Karachi', 'Pakistan', '+92-21-111-282-747', 'info@avari.com', 'https://www.avari.com');

go

-- Hotel Branches (38)

insert into HotelBranches(HotelID, BranchName, City, Country, AddressLine, PostalCode, Phone, Email, NumRooms) values
	(1, 'Islamabad Serena Hotel', 'Islamabad', 'Pakistan', 'Blue Area', '44000', '+92-51-111-133-101', 'islamabad@serenahotels.com', 30),
	(1, 'Faisalabad Serena Hotel', 'Faisalabad', 'Pakistan', 'Ghulam Muhammad Abad', '38000', '+92-41-111-133-102', 'faisalabad@serenahotels.com', 20),
	(1, 'Quetta Serena Hotel', 'Quetta', 'Pakistan', 'Chiltan Road', '87300', '+92-81-111-133-103', 'quetta@serenahotels.com', 0),
	(1, 'Swat Serena Hotel', 'Swat', 'Pakistan', 'Mingora', '19200', '+92-94-111-133-104', 'swat@serenahotels.com', 0),
	(1, 'Gilgit Serena Hotel', 'Gilgit', 'Pakistan', 'Jutial', '15100', '+92-581-111-133-105', 'gilgit@serenahotels.com', 0),
	(1, 'Hunza Serena Hotel', 'Hunza', 'Pakistan', 'Karimabad', '15110', '+92-581-111-133-106', 'hunza@serenahotels.com', 0),
	(1, 'Serena Shigar Fort', 'Shigar', 'Pakistan', 'Shigar', '16110', '+92-582-111-133-107', 'shigar@serenahotels.com', 0),
	(1, 'Serena Khaplu Palace', 'Khaplu', 'Pakistan', 'Khaplu', '18600', '+92-582-111-133-108', 'khaplu@serenahotels.com', 0),
	(1, 'Peshawar Serena Hotel', 'Peshawar', 'Pakistan', 'University Road', '25000', '+92-91-111-133-109', 'peshawar@serenahotels.com', 0),
	(1, 'Sost Serena Hotel', 'Sost', 'Pakistan', 'Sost', '15120', '+92-581-111-133-110', 'sost@serenahotels.com', 0),
	(1, 'Serena Altit Fort Residence', 'Hunza', 'Pakistan', 'Altit', '15111', '+92-581-111-133-111', 'altit@serenahotels.com', 0),
	(2, 'Pearl Continental Karachi', 'Karachi', 'Pakistan', 'Club Road', '74200', '+92-21-111-505-101', 'karachi@pchotels.com', 0),
	(2, 'Pearl Continental Rawalpindi', 'Rawalpindi', 'Pakistan', 'The Mall Road', '46000', '+92-51-111-505-102', 'rawalpindi@pchotels.com', 0),
	(2, 'Pearl Continental Islamabad', 'Islamabad', 'Pakistan', 'G-5 Sector', '44000', '+92-51-111-505-103', 'islamabad@pchotels.com', 0),
	(2, 'Pearl Continental Hotel Lahore', 'Lahore', 'Pakistan', 'Shahrah-e-Quaid-e-Azam', '54000', '+92-42-111-505-104', 'lahore@pchotels.com', 0),
	(2, 'Pearl Continental Bhurban', 'Bhurban', 'Pakistan', 'Bhurban Resort Area', '44150', '+92-51-111-505-105', 'bhurban@pchotels.com', 0),
	(2, 'Pearl Continental Muzaffarabad', 'Muzaffarabad', 'Pakistan', 'River View', '13100', '+92-58-111-505-106', 'muzaffarabad@pchotels.com', 0),
	(2, 'Pearl Continental Malam Jabba', 'Malam Jabba', 'Pakistan', 'Malam Jabba Ski Resort', '17250', '+92-94-111-505-107', 'malamjabba@pchotels.com', 0),
	(2, 'Rumanza Resort by Pearl-Continental', 'Multan', 'Pakistan', 'Multan Cantt', '60000', '+92-61-111-505-108', 'multan@pchotels.com', 0),
	(2, 'Pearl Continental Peshawar', 'Peshawar', 'Pakistan', 'University Road', '25000', '+92-91-111-505-109', 'peshawar@pchotels.com', 0),
	(2, 'Zavar Pearl Continental Hotel Gwadar', 'Gwadar', 'Pakistan', 'Gwadar Coastal Road', '91200', '+92-82-111-505-110', 'gwadar@pchotels.com', 0),
	(3, 'Ramada by Wyndham Lahore Gulberg II', 'Lahore', 'Pakistan', 'Gulberg II', '54000', '+92-42-111-660-101', 'lahore@ramada.com.pk', 0),
	(3, 'Ramada by Wyndham Islamabad', 'Islamabad', 'Pakistan', 'Blue Area', '44000', '+92-51-111-660-102', 'islamabad@ramada.com.pk', 0),
	(3, 'Ramada by Wyndham Karachi Creek', 'Karachi', 'Pakistan', 'Creek Road', '74200', '+92-21-111-660-103', 'karachi@ramada.com.pk', 0),
	(3, 'Ramada Plaza by Wyndham Karachi Airport', 'Karachi', 'Pakistan', 'Airport Road', '74200', '+92-21-111-660-104', 'airport@ramada.com.pk', 0),
	(3, 'Ramada by Wyndham Multan', 'Multan', 'Pakistan', 'Cantt Area', '60000', '+92-61-111-660-105', 'multan@ramada.com.pk', 0),
	(3, 'Ramada by Wyndham Murree Lower Topa Resort', 'Murree', 'Pakistan', 'Lower Topa', '44150', '+92-51-111-660-106', 'murree@ramada.com.pk', 0);

go

-- Total Guests (50)

Insert into Guests (FirstName, LastName, Email, Phone) values
	('Afshan','Raza','afshanraza@gmail.com','+923001234034'),
	('Taimoor','Ahmed','taimoorahhmed@gmail.com','+923001234035'),
	('Amina','Sheikh','aminasheikh@gmail.com','+923001234036'),
	('Shahzad','Khan','shahzadkhan@gmail.com','+923001234037'),
	('Mahnoor','Malik','mahnoormalik@gmail.com','+923001234038'),
	('Yasir','Raza','yasirraza@gmail.com','+923001234039'),
	('Sadia','Iqbal','sadiaiqbal@gmail.com','+923001234040'),
	('Kamran','Sheikh','kamransheikh@gmail.com','+923001234041'),
	('Aqsa','Khan','aqsakhan@gmail.com','+923001234042'),
	('Hammad','Ahmed','hammadahmed@gmail.com','+923001234043'),
	('Mehwish','Raza','mehwishraza@gmail.com','+923001234044'),
	('Furqan','Iqbal','furqaniqbal@gmail.com','+923001234045'),
	('Momina','Sheikh','mominasheikh@gmail.com','+923001234046'),
	('Talha','Khan','talhakhan@gmail.com','+923001234047'),
	('Sahar','Malik','saharmalik@gmail.com','+923001234048'),
	('Faizan','Raza','faizanraza@gmail.com','+923001234049'),
	('Noor','Ahmed','noorahmed@gmail.com','+923001234050'),
	('Adeel','Sheikh','adeelsheikh@gmail.com','+923001234051'),
	('Rania','Khan','raniakhan@gmail.com','+923001234052'),
	('Adnan','Malik','adnanmalik@gmail.com','+923001234053'),
	('Esha','Raza','esharaza@gmail.com','+923001234054'),
	('Waqar','Iqbal','waqariqbal@gmail.com','+923001234055'),
	('Nimra','Ahmed','nimraahmed@gmail.com','+923001234056'),
	('Rehan','Sheikh','rehansheikh@gmail.com','+923001234057'),
	('Sehrish','Malik','sehrishmalik@gmail.com','+923001234058'),
	('Zubair','Khan','zubairkhan@gmail.com','+923001234059'),
	('Alina','Raza','alinaraza@gmail.com','+923001234060'),
	('Faisal','Ahmed','faisalahmed@gmail.com','+923001234061'),
	('Anam','Sheikh','anamsheikh@gmail.com','+923001234062'),
	('Obaid','Iqbal','obaidiqbal@gmail.com','+923001234063'),
	('Hafsa','Khan','hafsakhan@gmail.com','+923001234064'),
	('Shayan','Malik','shayanmalik@gmail.com','+923001234065'),
	('Ruba','Ahmed','rubaahmed@gmail.com','+923001234066'),
	('Ismail','Raza','ismailraza@gmail.com','+923001234067'),
	('Zoya','Sheikh','zoyasheikh@gmail.com','+923001234068'),
	('Saqib','Khan','saqibkhan@gmail.com','+923001234069'),
	('Aiman','Raza','aimanraza@gmail.com','+923001234070'),
	('Jibran','Iqbal','jibraniqbal@gmail.com','+923001234071'),
	('Nargis','Ahmed','nargisahmed@gmail.com','+923001234072'),
	('Yahya','Sheikh','yahyasheikh@gmail.com','+923001234073'),
	('Tania','Malik','taniamalik@gmail.com','+923001234074'),
	('Hashim','Khan','hashimkhan@gmail.com','+923001234075'),
	('Fizza','Raza','fizzarazza@gmail.com','+923001234076'),
	('Qasim','Ahmed','qasimahmed@gmail.com','+923001234077'),
	('Rimsha','Sheikh','rimshasheikh@gmail.com','+923001234078'),
	('Haider','Iqbal','haideriqbal@gmail.com','+923001234079'),
	('Minal','Malik','minalmalik@gmail.com','+923001234080'),
	('Owais','Khan','owaiskhan@gmail.com','+923001234081'),
	('Laiba','Raza','laibaraza@gmail.com','+923001234082'),
	('Salman','Ahmed','salmanahmed@gmail.com','+923001234083');

go


-- Room Types (5) 

insert into RoomTypes (TypeName, BaseRate, Capacity) values

	('Standard Room', 15000.00, 2),
	('Deluxe Room', 22000.00, 3),
	('Executive Room', 30000.00, 3),
	('Suite', 35000.00, 4),
	('Presidential Suite', 60000.00, 5);

go

-- Room Status (4)

insert into RoomStatus (StatusName) values

	('Available'),
	('Occupied'),
	('Under Maintenance'),
	('Cleaning');

go


-- Total Rooms (50)
 
 insert into Rooms (BranchID, RoomNumber, FloorNumber, TypeID, IsPerfectView, StatusID) values

	(1,'101',1,1,0,1),
	(1,'102',1,1,0,1),
	(1,'103',1,2,0,1),
	(1,'104',1,2,0,1),
	(1,'105',1,3,0,1),
	(1,'106',1,3,0,1),
	(1,'201',2,1,0,1),
	(1,'202',2,1,0,1),
	(1,'203',2,2,0,1),
	(1,'204',2,2,0,1),
	(1,'205',2,3,0,1),
	(1,'206',2,3,0,1),
	(1,'301',3,1,0,1),
	(1,'302',3,1,0,1),
	(1,'303',3,2,0,1),
	(1,'304',3,2,0,1),
	(1,'305',3,3,0,1),
	(1,'306',3,3,0,1),
	(1,'401',4,2,0,1),
	(1,'402',4,2,0,1),
	(1,'403',4,3,0,1),
	(1,'404',4,3,0,1),
	(1,'405',4,4,1,1),
	(1,'406',4,4,1,1),
	(1,'501',5,5,1,1),
	(1,'502',5,5,1,1),
	(1,'503',5,4,1,1),
	(1,'504',5,4,1,1),
	(1,'505',5,3,0,1),
	(1,'506',5,3,0,1),
	(2,'101',1,1,0,1),
	(2,'102',1,1,0,1),
	(2,'103',1,2,0,1),
	(2,'104',1,2,0,1),
	(2,'105',1,3,0,1),
	(2,'106',1,3,0,1),
	(2,'201',2,1,0,1),
	(2,'202',2,1,0,1),
	(2,'203',2,2,0,1),
	(2,'204',2,2,0,1),
	(2,'205',2,3,0,1),
	(2,'206',2,3,0,1),
	(2,'301',3,1,0,1),
	(2,'302',3,1,0,1),
	(2,'303',3,2,0,1),
	(2,'304',3,2,0,1),
	(2,'305',3,3,0,1),
	(2,'306',3,3,0,1),
	(2,'401',4,2,0,1),
	(2,'402',4,2,0,1);
go

-- Reservations (50)

INSERT INTO Reservations (GuestID, RoomID, BranchID, CheckIn, NumGuests, Rate) VALUES
(1, 17, 1, '2025-12-02', 3, 7960),
(2, 12, 1, '2025-12-25', 1, 7591),
(3, 18, 1, '2025-12-02', 2, 9256),
(4, 3, 1, '2025-12-28', 1, 9676),
(5, 50, 2, '2025-12-30', 1, 9342),
(6, 42, 2, '2025-12-05', 2, 8017),
(7, 19, 1, '2025-12-15', 1, 7106),
(8, 18, 1, '2025-12-20', 2, 7311),
(9, 44, 2, '2025-12-06', 2, 8699),
(10, 10, 1, '2025-12-16', 2, 7172),
(11, 21, 1, '2025-12-24', 3, 8899),
(12, 44, 2, '2025-12-09', 1, 9457),
(13, 20, 1, '2025-12-21', 3, 9514),
(14, 37, 2, '2025-12-10', 1, 9732),
(15, 8, 1, '2025-12-04', 1, 9440),
(16, 37, 2, '2025-12-16', 2, 8150),
(17, 1, 1, '2025-12-17', 2, 7892),
(18, 9, 1, '2025-12-11', 3, 8297),
(19, 2, 1, '2025-12-24', 2, 8421),
(20, 33, 2, '2025-12-04', 2, 8936),
(21, 12, 1, '2025-12-26', 3, 7582),  
(22, 49, 2, '2025-12-24', 3, 8036),
(23, 26, 1, '2025-12-31', 4, 9727),
(24, 28, 1, '2025-12-25', 2, 9981),
(25, 18, 1, '2025-12-26', 3, 7342),
(26, 17, 1, '2025-12-08', 1, 7966),
(27, 47, 2, '2025-12-13', 1, 7248),
(28, 8, 1, '2025-12-16', 2, 7912),
(29, 23, 1, '2025-12-04', 4, 9986),
(30, 44, 2, '2025-12-12', 2, 7379),
(31, 33, 2, '2025-12-08', 2, 7574),
(32, 4, 1, '2025-12-29', 1, 7238),
(33, 19, 1, '2025-12-13', 3, 8379),
(34, 50, 2, '2025-12-11', 1, 7019),
(35, 6, 1, '2025-12-12', 1, 7575),
(36, 3, 1, '2025-12-27', 3, 7516),
(37, 11, 1, '2025-12-08', 3, 8734),
(38, 16, 1, '2025-12-26', 3, 7133),
(39, 9, 1, '2025-12-12', 2, 9693),  
(40, 24, 1, '2025-12-13', 3, 8124),
(41, 46, 2, '2025-12-27', 2, 7965),
(42, 46, 2, '2025-12-25', 2, 8244),
(43, 14, 1, '2025-12-03', 2, 8272),
(44, 6, 1, '2025-12-07', 3, 9443),
(45, 18, 1, '2025-12-13', 3, 7429),
(46, 44, 2, '2025-12-19', 2, 8851),
(47, 48, 2, '2025-12-22', 1, 8746),
(48, 32, 2, '2025-12-11', 2, 9422),
(49, 1, 1, '2025-12-06', 2, 8787),
(50, 13, 1, '2025-12-20', 2, 8106);

go


-- Facility Type (15)

INSERT INTO FacilityType (FacilityName, Descriptions) VALUES
('Free Wi-Fi', 'High-speed wireless internet available throughout the property'),
('Swimming Pool', 'Outdoor or indoor pool available for guests'),
('Gym / Fitness Center', 'Fully equipped fitness center open 24/7'),
('Spa & Wellness Center', 'Massage, sauna, and relaxation services'),
('Breakfast Included', 'Complimentary breakfast for all guests'),
('Parking', 'Free or paid parking available on premises'),
('24/7 Front Desk', 'Reception desk available round the clock'),
('Room Service', 'Food and drinks delivered to rooms'),
('Airport Shuttle', 'Transportation service to and from the airport'),
('Laundry Service', 'Washing, ironing, and dry cleaning services'),
('Restaurant', 'In-house dining facility'),
('Business Center', 'Computers, printers, and meeting rooms available'),
('Pet Friendly', 'Hotel allows pets'),
('Wheelchair Accessible', 'Facilities for disabled guests'),
('Housekeeping', 'Daily room cleaning service');

go

-- Guest Facility Usage (50)

INSERT INTO GuestFacilityUsage (GuestID, FacilityTypeID, Quantity, ChargeAmount, Notes) VALUES
(1, 1, 4, 119.19, 'Excellent'),
(2, 15, 5, 108.34, 'Excellent'),
(3, 15, 1, 107.34, 'Excellent'),
(4, 15, 2, 183.03, 'Need to improve'),
(5, 14, 1, 154.19, 'Good'),
(6, 6, 3, 32.51, 'Excellent'),
(7, 10, 1, 5.54, 'Excellent'),
(8, 6, 1, 167.71, 'Excellent'),
(9, 8, 4, 114.34, 'Excellent'),
(10, 9, 1, 83.88, 'Need to improve'),
(11, 12, 1, 64.86, 'Excellent'),
(12, 10, 3, 10.52, 'Need to improve'),
(13, 1, 3, 83.95, 'Excellent'),
(14, 15, 1, 182.81, 'Good'),
(15, 4, 2, 63.38, 'Need to improve'),
(16, 3, 2, 189.51, 'Excellent'),
(17, 13, 3, 150.79, 'Excellent'),
(18, 11, 4, 181.13, 'Good'),
(19, 15, 4, 75.03, 'Excellent'),
(20, 15, 1, 171.67, 'Good'),
(21, 4, 5, 89.69, 'Excellent'),
(22, 4, 5, 57.50, 'Excellent'),
(23, 10, 2, 163.24, 'Good'),
(24, 2, 3, 166.41, 'Excellent'),
(25, 8, 3, 84.11, 'Need to improve'),
(26, 7, 1, 189.04, 'Excellent'),
(27, 12, 5, 180.98, 'Need to improve'),
(28, 10, 5, 41.91, 'Good'),
(29, 2, 3, 38.77, 'Good'),
(30, 12, 2, 162.15, 'Need to improve'),
(31, 14, 5, 86.88, 'Good'),
(32, 15, 5, 41.13, 'Need to improve'),
(33, 14, 3, 5.72, 'Excellent'),
(34, 9, 2, 15.90, 'Good'),
(35, 11, 3, 37.33, 'Excellent'),
(36, 10, 2, 48.98, 'Good'),
(37, 12, 5, 173.20, 'Good'),
(38, 2, 4, 12.97, 'Excellent'),
(39, 10, 4, 11.33, 'Excellent'),
(40, 8, 4, 182.69, 'Need to improve'),
(41, 11, 4, 164.85, 'Good'),
(42, 15, 3, 112.50, 'Excellent'),
(43, 9, 2, 43.05, 'Good'),
(44, 6, 1, 182.98, 'Good'),
(45, 1, 4, 87.75, 'Excellent'),
(46, 11, 2, 93.74, 'Excellent'),
(47, 8, 5, 137.92, 'Need to improve'),
(48, 7, 3, 18.91, 'Excellent'),
(49, 11, 3, 107.09, 'Excellent'),
(50, 4, 2, 120.37, 'Need to improve');

go

-- Employees (50)

INSERT INTO Employees (BranchID, FirstName, LastName, Email, Phone) VALUES
(1, 'Ali', 'Khan', 'ali.khan1@serenahotels.com', '+92-300-1000001'),
(1, 'Sara', 'Ahmed', 'sara.ahmed1@serenahotels.com', '+92-300-1000002'),
(1, 'Usman', 'Raza', 'usman.raza1@serenahotels.com', '+92-300-1000003'),
(1, 'Ayesha', 'Shah', 'ayesha.shah1@serenahotels.com', '+92-300-1000004'),
(1, 'Hassan', 'Ali', 'hassan.ali1@serenahotels.com', '+92-300-1000005'),
(1, 'Zain', 'Iqbal', 'zain.iqbal1@serenahotels.com', '+92-300-1000006'),
(1, 'Maria', 'Khan', 'maria.khan1@serenahotels.com', '+92-300-1000007'),
(1, 'Bilal', 'Hussain', 'bilal.hussain1@serenahotels.com', '+92-300-1000008'),
(1, 'Hira', 'Rashid', 'hira.rashid1@serenahotels.com', '+92-300-1000009'),
(1, 'Tariq', 'Javed', 'tariq.javed1@serenahotels.com', '+92-300-1000010'),
(1, 'Ahmed', 'Shah', 'ahmed.shah1@serenahotels.com', '+92-300-1000011'),
(1, 'Sana', 'Malik', 'sana.malik1@serenahotels.com', '+92-300-1000012'),
(1, 'Omar', 'Ali', 'omar.ali1@serenahotels.com', '+92-300-1000013'),
(1, 'Nadia', 'Khan', 'nadia.khan1@serenahotels.com', '+92-300-1000014'),
(1, 'Faisal', 'Rashid', 'faisal.rashid1@serenahotels.com', '+92-300-1000015'),
(1, 'Sami', 'Ahmed', 'sami.ahmed1@serenahotels.com', '+92-300-1000016'),
(1, 'Amina', 'Khalid', 'amina.khalid1@serenahotels.com', '+92-300-1000017'),
(1, 'Shahbaz', 'Ali', 'shahbaz.ali1@serenahotels.com', '+92-300-1000018'),
(1, 'Lubna', 'Qureshi', 'lubna.qureshi1@serenahotels.com', '+92-300-1000019'),
(1, 'Naveed', 'Hussain', 'naveed.hussain1@serenahotels.com', '+92-300-1000020'),
(2, 'Hafsa', 'Ali', 'hafsa.ali1@serenahotels.com', '+92-300-1000021'),
(2, 'Shahid', 'Khan', 'shahid.khan1@serenahotels.com', '+92-300-1000022'),
(2, 'Sobia', 'Rashid', 'sobia.rashid1@serenahotels.com', '+92-300-1000023'),
(2, 'Usama', 'Javed', 'usama.javed1@serenahotels.com', '+92-300-1000024'),
(2, 'Faiza', 'Shah', 'faiza.shah1@serenahotels.com', '+92-300-1000025'),
(2, 'Raza', 'Khan', 'raza.khan1@serenahotels.com', '+92-300-1000026'),
(2, 'Maryam', 'Ali', 'maryam.ali1@serenahotels.com', '+92-300-1000027'),
(2, 'Hamza', 'Malik', 'hamza.malik1@serenahotels.com', '+92-300-1000028'),
(2, 'Sadia', 'Rashid', 'sadia.rashid1@serenahotels.com', '+92-300-1000029'),
(2, 'Shafaq', 'Javed', 'shafaq.javed1@serenahotels.com', '+92-300-1000030'),
(2, 'Zoya', 'Khan', 'zoya.khan1@serenahotels.com', '+92-300-1000031'),
(2, 'Irfan', 'Ali', 'irfan.ali1@serenahotels.com', '+92-300-1000032'),
(2, 'Amna', 'Shah', 'amna.shah1@serenahotels.com', '+92-300-1000033'),
(2, 'Rehan', 'Rashid', 'rehan.rashid1@serenahotels.com', '+92-300-1000034'),
(2, 'Kiran', 'Malik', 'kiran.malik1@serenahotels.com', '+92-300-1000035'),
(2, 'Danish', 'Khan', 'danish.khan1@serenahotels.com', '+92-300-1000036'),
(2, 'Noor', 'Ali', 'noor.ali1@serenahotels.com', '+92-300-1000037'),
(2, 'Samiya', 'Shah', 'samiya.shah1@serenahotels.com', '+92-300-1000038'),
(2, 'Asad', 'Rashid', 'asad.rashid1@serenahotels.com', '+92-300-1000039'),
(2, 'Huma', 'Malik', 'huma.malik1@serenahotels.com', '+92-300-1000040'),
(2, 'Zainab', 'Khan', 'zainab.khan1@serenahotels.com', '+92-300-1000041'),
(2, 'Bilal', 'Shah', 'bilal.shah1@serenahotels.com', '+92-300-1000042'),
(2, 'Hira', 'Ali', 'hira.ali1@serenahotels.com', '+92-300-1000043'),
(2, 'Tariq', 'Malik', 'tariq.malik1@serenahotels.com', '+92-300-1000044'),
(2, 'Sania', 'Rashid', 'sania.rashid1@serenahotels.com', '+92-300-1000045'),
(2, 'Omar', 'Khan', 'omar.khan1@serenahotels.com', '+92-300-1000046'),
(2, 'Fiza', 'Shah', 'fiza.shah1@serenahotels.com', '+92-300-1000047'),
(2, 'Ayaan', 'Ali', 'ayaan.ali1@serenahotels.com', '+92-300-1000048'),
(2, 'Maryam', 'Malik', 'maryam.malik2@serenahotels.com', '+92-300-1000049'),
(2, 'Hassan', 'Rashid', 'hassan.rashid2@serenahotels.com', '+92-300-1000050');

go

-- Invoices (50 Invoices for 50 Reservtions)

INSERT INTO Invoices (ReservationID, Subtotal, Taxes, Discounts, Total) VALUES
(1, 6504.85, 777.89, 106.35, 7176.39),
(2, 5755.13, 409.28, 173.16, 5991.25),
(3, 6625.36, 323.39, 125.07, 6823.68),
(4, 6219.3, 489.55, 244.53, 6464.320000000001),
(5, 6880.76, 560.81, 469.67, 6971.9),
(6, 6870.01, 748.15, 92.99, 7525.17),
(7, 6863.46, 562.35, 108.35, 7317.46),
(8, 5557.17, 536.01, 115.9, 5977.280000000001),
(9, 5772.01, 629.17, 460.71, 5940.47),
(10, 5823.35, 519.37, 112.48, 6230.240000000001),
(11, 5506.81, 734.17, 267.96, 5973.02),
(12, 6121.83, 713.22, 139.59, 6695.46),
(13, 6175.47, 405.04, 137.19, 6443.320000000001),
(14, 6852.19, 441.24, 21.86, 7271.57),
(15, 5632.69, 366.55, 178.58, 5820.66),
(16, 5950.38, 623.39, 58.45, 6515.320000000001),
(17, 6433.21, 368.58, 64.38, 6737.41),
(18, 6039.63, 493.47, 112.26, 6420.84),
(19, 6479.2, 442.71, 313.26, 6608.65),
(20, 5638.16, 537.35, 114.16, 6061.35),
(21, 5517.73, 757.61, 66.0, 6209.339999999999),
(22, 5630.86, 427.56, 197.92, 5860.5),
(23, 5852.08, 626.8, 288.75, 6190.13),
(24, 6320.32, 437.16, 176.4, 6581.08),
(25, 6456.78, 340.19, 176.88, 6620.089999999999),
(26, 6212.14, 757.45, 158.36, 6811.2300000000005),
(27, 6660.42, 508.78, 456.81, 6712.389999999999),
(28, 6745.23, 670.85, 173.89, 7242.19),
(29, 6259.69, 334.63, 66.78, 6527.54),
(30, 6708.16, 454.71, 233.29, 6929.58),
(31, 6765.76, 795.81, 357.53, 7204.04),
(32, 6816.51, 670.81, 112.95, 7374.37),
(33, 5516.56, 543.54, 106.68, 5953.42),
(34, 6119.52, 454.22, 457.44, 6116.300000000001),
(35, 5756.07, 361.34, 440.84, 5676.57),
(36, 6763.95, 764.47, 194.02, 7334.4),
(37, 5577.98, 750.58, 361.53, 5967.03),
(38, 6305.37, 490.3, 290.44, 6505.2300000000005),
(39, 6543.41, 478.14, 53.04, 6968.51),
(40, 6351.92, 460.62, 257.6, 6554.94),
(41, 6926.93, 415.82, 423.35, 6919.4),
(42, 5550.05, 509.42, 374.57, 5684.900000000001),
(43, 5842.37, 665.46, 477.57, 6030.26),
(44, 5555.69, 722.28, 6.61, 6271.36),
(45, 6713.76, 556.67, 310.51, 6959.92),
(46, 6446.78, 442.86, 182.99, 6706.65),
(47, 6950.24, 603.24, 227.22, 7326.259999999999),
(48, 6885.53, 681.88, 217.05, 7350.36),
(49, 6627.28, 652.61, 462.02, 6817.869999999999),
(50, 6786.69, 402.69, 40.2, 7149.179999999999);

go

-- Payments (50 Payments for 50 Invoices)
-- Example: 1 = Cash, 2 = Card, 3 = Online

INSERT INTO Payments (InvoiceID, PaymentType, PaidAt) VALUES
(1, 3, '2025-11-17 06:48:45'),
(2, 1, '2025-11-05 20:59:32'),
(3, 2, '2025-11-14 22:03:28'),
(4, 1, '2025-11-28 10:15:25'),
(5, 2, '2025-11-07 07:36:39'),
(6, 1, '2025-11-07 01:33:24'),
(7, 2, '2025-11-09 14:10:23'),
(8, 3, '2025-11-10 14:08:33'),
(9, 3, '2025-11-25 10:01:12'),
(10, 2, '2025-11-07 03:45:52'),
(11, 1, '2025-11-16 21:36:24'),
(12, 1, '2025-11-25 12:38:23'),
(13, 1, '2025-11-10 13:22:19'),
(14, 2, '2025-11-07 00:53:00'),
(15, 1, '2025-11-27 14:44:41'),
(16, 2, '2025-11-13 15:19:40'),
(17, 3, '2025-11-28 19:16:26'),
(18, 1, '2025-11-16 18:52:16'),
(19, 2, '2025-11-07 17:57:03'),
(20, 2, '2025-11-01 10:17:32'),
(21, 2, '2025-11-08 17:33:19'),
(22, 3, '2025-11-28 08:20:07'),
(23, 3, '2025-11-29 02:12:02'),
(24, 2, '2025-11-11 17:29:30'),
(25, 3, '2025-11-02 08:19:51'),
(26, 3, '2025-11-02 00:40:01'),
(27, 1, '2025-11-07 15:45:53'),
(28, 1, '2025-10-31 12:18:41'),
(29, 3, '2025-10-30 13:55:13'),
(30, 2, '2025-10-31 16:12:09'),
(31, 1, '2025-11-22 07:37:44'),
(32, 1, '2025-11-11 00:24:05'),
(33, 2, '2025-11-02 04:15:44'),
(34, 3, '2025-11-18 19:22:29'),
(35, 3, '2025-11-28 10:26:00'),
(36, 1, '2025-11-04 13:41:44'),
(37, 3, '2025-11-18 08:18:16'),
(38, 3, '2025-11-21 22:32:17'),
(39, 2, '2025-11-13 23:17:38'),
(40, 2, '2025-11-15 16:42:52'),
(41, 2, '2025-11-15 22:47:06'),
(42, 3, '2025-11-03 07:19:25'),
(43, 1, '2025-11-15 23:44:38'),
(44, 3, '2025-11-21 18:35:40'),
(45, 1, '2025-11-21 18:34:28'),
(46, 1, '2025-11-19 15:23:32'),
(47, 3, '2025-11-09 01:06:43'),
(48, 2, '2025-11-25 07:29:48'),
(49, 1, '2025-11-26 09:10:47'),
(50, 3, '2025-11-27 15:39:36');

go

-- Services (8)

insert into Services(ServiceName) values

	('Room Booking'),
	('Laundry Service'),
	('Room Service'),
	('Spa & Wellness'),
	('Restaurant & Dining'),
	('Airport Pickup/Drop'),
	('Gym & Fitness'),
	('Conference Hall Booking');

go

-- Service Staff (50)

INSERT INTO ServiceStaff (EmployeeID, Department, ShiftTime, IsOnDuty, ExperienceYears)
VALUES
(1, 'Housekeeping', 'Morning', 1, 5),
(2, 'Housekeeping', 'Evening', 1, 3),
(3, 'Housekeeping', 'Night', 1, 4),
(4, 'Housekeeping', 'Morning', 1, 6),
(5, 'Housekeeping', 'Evening', 1, 2),
(6, 'Room Service', 'Morning', 1, 4),
(7, 'Room Service', 'Evening', 1, 5),
(8, 'Room Service', 'Night', 1, 3),
(9, 'Laundry', 'Morning', 1, 4),
(10, 'Laundry', 'Evening', 1, 2),
(11, 'Laundry', 'Night', 1, 3),
(12, 'Maintenance', 'Morning', 1, 6),
(13, 'Maintenance', 'Evening', 1, 5),
(14, 'Maintenance', 'Night', 1, 4),
(15, 'Security', 'Morning', 1, 7),
(16, 'Security', 'Evening', 1, 5),
(17, 'Housekeeping', 'Morning', 1, 3),
(18, 'Room Service', 'Night', 1, 2),
(19, 'Housekeeping', 'Evening', 1, 4),
(20, 'Maintenance', 'Night', 1, 3),
(21, 'Laundry', 'Morning', 1, 2),
(22, 'Security', 'Night', 1, 4),
(23, 'Room Service', 'Evening', 1, 3),
(24, 'Housekeeping', 'Morning', 1, 5),
(25, 'Maintenance', 'Evening', 1, 4),
(26, 'Housekeeping', 'Morning', 1, 4),
(27, 'Housekeeping', 'Evening', 1, 5),
(28, 'Housekeeping', 'Night', 1, 3),
(29, 'Housekeeping', 'Morning', 1, 6),
(30, 'Housekeeping', 'Evening', 1, 4),
(31, 'Room Service', 'Morning', 1, 5),
(32, 'Room Service', 'Evening', 1, 3),
(33, 'Room Service', 'Night', 1, 2),
(34, 'Laundry', 'Morning', 1, 4),
(35, 'Laundry', 'Evening', 1, 3),
(36, 'Laundry', 'Night', 1, 2),
(37, 'Maintenance', 'Morning', 1, 5),
(38, 'Maintenance', 'Evening', 1, 4),
(39, 'Maintenance', 'Night', 1, 3),
(40, 'Security', 'Morning', 1, 6),
(41, 'Security', 'Evening', 1, 5),
(42, 'Housekeeping', 'Morning', 1, 3),
(43, 'Room Service', 'Night', 1, 4),
(44, 'Housekeeping', 'Evening', 1, 2),
(45, 'Maintenance', 'Night', 1, 4),
(46, 'Laundry', 'Morning', 1, 3),
(47, 'Security', 'Night', 1, 2),
(48, 'Room Service', 'Evening', 1, 5),
(49, 'Housekeeping', 'Morning', 1, 4),
(50, 'Maintenance', 'Evening', 1, 3);

go

-- Service Orders (50)

INSERT INTO ServiceOrders (EmployeeID, ReservationID, ServiceID) VALUES
(18, 44, 5),
(26, 22, 1),
(25, 18, 7), 
(44, 43, 3),
(29, 33, 2),  
(4, 10, 5),
(5, 36, 8),
(26, 16, 5),
(38, 39, 6),
(26, 42, 5),
(19, 28, 4),
(11, 26, 7),
(28, 24, 6),
(8, 3, 7),
(49, 37, 3),
(46, 28, 4),
(50, 11, 5),
(6, 13, 2),
(46, 17, 2),
(26, 30, 2),
(21, 19, 2),  
(25, 3, 7),   
(16, 34, 5),
(25, 37, 8),
(22, 49, 1),
(18, 33, 2),
(18, 32, 7),
(47, 49, 8),
(34, 6, 1),
(12, 7, 6),
(26, 5, 6),
(39, 47, 1),
(31, 40, 7),
(44, 26, 7),
(35, 43, 1),
(14, 27, 8),
(11, 28, 3),
(26, 22, 2),
(19, 39, 6),
(25, 34, 4),
(26, 42, 8),
(27, 7, 5),
(29, 4, 3),
(22, 34, 8),
(21, 18, 2),
(6, 27, 5),
(22, 43, 6),
(25, 28, 4),
(7, 13, 2),
(46, 29, 1);

go

-- Complex Queries

-- 1) Employees with the most service orders per department grouped by their department?

SELECT 
    ss.Department,
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(so.ServiceOrderID) AS NumOrders
FROM ServiceStaff ss
JOIN Employees e ON ss.EmployeeID = e.EmployeeID
LEFT JOIN ServiceOrders so ON e.EmployeeID = so.EmployeeID
GROUP BY ss.Department, e.EmployeeID, e.FirstName, e.LastName
ORDER BY ss.Department, NumOrders DESC;

go

-- 2) Most used facilities by guests (shows which guests used facilities most frequently)?

SELECT 
    g.GuestID,
    g.FirstName,
    g.LastName,
    COUNT(gfu.UsageID) AS FacilityUsageCount,
    STRING_AGG(f.FacilityName, ', ') AS FacilitiesUsed
FROM Guests g
JOIN GuestFacilityUsage gfu ON g.GuestID = gfu.GuestID
JOIN FacilityType f ON gfu.FacilityTypeID = f.FacilityTypeID
GROUP BY g.GuestID, g.FirstName, g.LastName
ORDER BY FacilityUsageCount DESC;

go

-- 3) Which service staff have given service to guest with id 1?

SELECT 
    ss.EmployeeID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    so.ServiceOrderID,
    so.ServiceID,
    s.ServiceName,
    r.ReservationID,
    r.GuestID
FROM ServiceOrders so
JOIN Reservations r ON so.ReservationID = r.ReservationID
JOIN ServiceStaff ss ON so.EmployeeID = ss.EmployeeID
JOIN Employees e ON ss.EmployeeID = e.EmployeeID
JOIN Services s ON so.ServiceID = s.ServiceID
WHERE r.GuestID = 1
ORDER BY so.ServiceOrderID;

go

-- 4) How many reservations in each branch?

SELECT 
    hb.BranchID,
    hb.BranchName,
    h.HotelName,
    COUNT(r.ReservationID) AS NumReservations
FROM HotelBranches hb
JOIN Hotels h ON hb.HotelID = h.HotelID
LEFT JOIN Reservations r ON hb.BranchID = r.BranchID
GROUP BY hb.BranchID, hb.BranchName, h.HotelName
ORDER BY NumReservations DESC;

go

-- 5) Invoice of Ahmed?

SELECT 
    g.GuestID,
    g.FirstName AS GuestFirstName,
    g.LastName AS GuestLastName,
    r.ReservationID,
    i.InvoiceID,
    i.Subtotal,
    i.Taxes,
    i.Discounts,
    i.Total
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
JOIN Invoices i ON r.ReservationID = i.ReservationID
WHERE g.FirstName = 'Ahmed'
ORDER BY i.InvoiceID;

go

