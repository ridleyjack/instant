drop table SelectsPrize;

drop table StoresProduct;

drop table Prize;

drop table DegreeOrder;

drop table Comment;

drop table Review;

drop table ProductSelection;

drop table Product;

drop table Shipment;

drop table CustomerOrder;

drop table Address;

drop table Customer;

drop table Account;

drop table University;

drop table ProductCategory;

drop table Discipline;

drop table Warehouse;

drop table Image;

Create Table Account(
accountId int primary key auto_increment,
loginName varchar(255) not null unique,
password varchar(64) not null,
creationDate Date not null,
lastLogin Date,
cname varchar(255),
email varchar(255) not null,
isDeactivated bool not null,
adminLevel int not null default 0
);

Create Table Customer(
accountId int primary key,
prizePoints int not null,
isWarned boolean not null,
isBanned boolean not null,
foreign key(accountId) References Account(accountId)
);

Create Table Address(
addressId int primary key auto_increment,
typCode varchar(1),
street varchar(255),
city varchar(255),
postalCode char(6),
accountId int not null,
foreign key(accountId) references Account(accountId)
	on delete cascade on update cascade
);

Create Table Image(
imageId int primary key Auto_Increment,
fileName varchar(255),
imageData blob not null
);

Create Table Prize(
prizeId int primary key auto_increment,
name varchar(255),
description varchar(255),
pointCost int not null,
imageId int,
foreign key(imageId) references Image(imageId)
	on delete set null on update cascade
);

Create Table CustomerOrder(
orderId int primary key auto_increment,
placed date,
totalCost decimal(6,2),
pointsEarned int,
accountId int not null,
foreign key(accountId) References Customer(accountId)
	on delete set null on update cascade
);

Create Table Shipment(
shipmentId int primary key,
shipped Date,
recieved Date,
readyToShip boolean default false not null,
shipped boolean default false not null,
orderId int not null,
addressId int not null,
foreign key(orderID) references CustomerOrder(orderId)
	 on update cascade,
foreign key(addressId) references Address(addressId)
	 on update cascade
);

Create Table University(
name varchar(255) primary key,
description varchar(1000),
imageId int,
foreign key(imageId) References Image(imageId)
	on delete set null on update cascade
);

create Table Discipline(
name varchar(255) primary key,
description varchar(1000)
);

Create Table DegreeOrder(
degreeId int primary key auto_increment,
nameField varchar(255),
dateField varchar(255),
withHonours bool,
withDistinction bool,
uniName varchar(255),
dicName varchar(255),
shipmentId int,
createdBy int not null,
foreign key(uniName) References University(name)
	on delete set null on update cascade,
foreign key(dicName) References Discipline(name)
	on delete set null on update cascade,
foreign key(shipmentId) References Shipment(shipmentId)
	on delete set null on update cascade,
foreign key(createdBy) References Account(accountId)
	on delete cascade on update cascade
);

Create Table ProductCategory(
categoryId int primary key auto_increment,
catName varchar(255),
description varchar(255),
imageId int,
foreign key(imageId) References Image(imageId)
	on delete set null on update cascade
);

Create Table Warehouse(
warehouseId int primary key,
street varchar(255),
city varchar(255),
postalCode char(6)
);

Create Table Product(
productId int primary key auto_increment,
pname varchar(255) not null,
description varchar(255),
price Decimal(6,2) not null,
pointValue int not null,
categoryId int not null,
imageId int,
foreign key(categoryId) References ProductCategory(categoryId)
	on delete no action on update cascade,
foreign key(imageId) References Image(imageId)
	on delete set null on update cascade
);

Create Table ProductSelection(
productId int,
warehouseId int,
shipmentId int,
amount int,
primary key(productId, warehouseId, shipmentId),
foreign key(productId) references Product(productId)
	on update cascade,
foreign key(warehouseId) references Warehouse(warehouseId)
	on update cascade,
foreign key(shipmentId) references Shipment(shipmentId)
	on update cascade
);

create Table Review(
reviewId int primary key auto_increment,
description varchar(1000),
rating varchar(1),
accountId int not null,
productId int not null,
foreign key(accountId) references Customer(accountId)
	on delete cascade,
foreign key(productId) references Product(productId)
	on delete cascade
);

create Table Comment(
reviewId int,
commentId int,
msg varchar(500),
isHidden bool,
isLocked bool,
accountId int,
primary key(reviewId, commentId),
foreign key(reviewId) references Review(reviewId)
	on update cascade,
foreign key(accountId) References Account(accountId)
     on delete cascade on update cascade	
);

create Table SelectsPrize(
accountId int,
prizeId int,
quantity int not null default 1,
primary key(accountId, prizeId),
foreign key(accountId) References Customer(accountId)
	on update cascade,
foreign key(prizeId) References Prize(prizeId)
	on update cascade
);

Create Table StoresProduct(
warehouseId int,
productId int,
amount int not null default 0,
primary key (warehouseId, productId),
foreign key (warehouseId) References Warehouse(warehouseId)
	on delete cascade on update cascade,
foreign key(productId) References Product(productId)
	on update cascade 
);

Insert Into ProductCategory(catName, description, imageId)
	Values("Clothing", "Things you can wear", null);
SET @lastid = LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("T-Shirt", "It's a shirt.", 40.50, 500, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("Pants", "It's some pants.", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("Hat", "A hat to wear on your head.", 35.75, 500, @lastid, null);
	
Insert Into ProductCategory(catName, description, imageId)
	Values("Cups", "Drink out of these", null);
SET @lastid =  LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("CoffeeMug", "Mug for keeping coffee in", 5.75, 10, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("Glass", "A glass", 5.75, 10, @lastid, null);

Insert Into Discipline(name, description)
	Values("Computer Science", "Bachelor of Science, with a major in Computer Science");
Insert Into Discipline(name, description)
	Values("Biology", "Bachelor of Science, with a major in Biology");
Insert Into Discipline(name, description)
	Values("Chemistry", "Bachelor of Science, with a major in Chemistry");	

Insert Into University(name, description, imageId)
	Values("UBC Okanagan", "A University located in Kelowna", null);
Insert Into University(name, description, imageId)
	Values("UBC Vancouver", "A University located in Vancouver", null);

Insert Into Account
(loginName, password, creationDate, LastLogin, cname, email, isDeactivated)
Values("guest", "5sPaWyBmNNfz81htdH/9s2tcZ1dXs4DGpf5cVwxxQ0k=", DATE('2017-11-19'), DATE('2017-11-19'), "guest", "guest@email.com", false);
SET @lastid = LAST_INSERT_ID();
Insert Into Customer(accountId, prizePoints, isWarned, isBanned)
Values(@lastid, 0, false, false);
Insert Into Address(typCode, street, city, postalCode, accountId)
Values(0, "1245 Guest Street NW", "Kelowna", "G1Y4R3", @lastid);

Insert Into Warehouse
(warehouseId, street, city, postalCode)
Values(1, "1914 Fake Street", "Kelowna", "R4W7Q1");

Insert Into Warehouse
(warehouseId, street, city, postalCode)
Values(2, "1939 Real Street", "Prince George", "A8C1T4");

select @prodId := productId From Product Where pname ="Pants";  
Insert Into StoresProduct
(warehouseId, productId, amount)
Values(1, @prodId, 10);

select @prodId := productId From Product Where pname ="Pants";  
Insert Into StoresProduct
(warehouseId, productId, amount)
Values(2, @prodId, 10);

select @prodId := productId From Product Where pname ="Hat";  
Insert Into StoresProduct
(warehouseId, productId, amount)
Values(1, @prodId, 50);

select @prodId := productId From Product Where pname ="Glass";  
Insert Into StoresProduct
(warehouseId, productId, amount)
Values(2, @prodId, 5);

select @prodId := productId From Product Where pname="Hat";
Insert Into Review( description, rating, accountId, productId)
Values("I like to wear the hat on my head", 4, 1, @prodId);

select @prodId := productId From Product Where pname="Hat";
Insert Into Review( description, rating, accountId, productId)
Values("I do not like to wear the hat on my head", 1, 1, @prodId);

