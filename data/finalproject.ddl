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

drop table Dicipline;

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
imageId int primary key,
caption varchar(255),
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
status int not null default 0,
placed date,
amountPaid decimal(6,2),
pointsEarned int,
taxRateAtPurchase decimal(2,2),
accountId int,
foreign key(accountId) References Customer(accountId)
	on delete set null on update cascade
);

Create Table Shipment(
shipmentId int primary key,
shipped Date,
recieved Date,
statusCode int not null default 0,
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

create Table Dicipline(
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
shipmentId int not null,
foreign key(uniName) References University(name)
	on delete set null on update cascade,
foreign key(dicName) References Dicipline(name)
	on delete set null on update cascade,
foreign key(shipmentId) References Shipment(shipmentId)
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
optionsCode int not null,
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
isHidden bool,
isLocked bool,
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
Insert Into Product(pname, description, price, pointValue, optionsCode, categoryId, imageId)
	Values("T-Shirt", "It's a shirt.", 40.50, 500, 0, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, optionsCode, categoryId, imageId)
	Values("Pants", "It's some pants.", 35.75, 500, 0, @lastid, null);
Insert Into Product(pname, description, price, pointValue, optionsCode, categoryId, imageId)
	Values("Hat", "A hat to wear on your head.", 35.75, 500, 0, @lastid, null);
	
Insert Into ProductCategory(catName, description, imageId)
	Values("Cups", "Drink out of these", null);
SET @lastid =  LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, optionsCode, categoryId, imageId)
	Values("CoffeeMug-UBCO", "It's a mug from the UBCO bookstore", 5.75, 10, 0, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, optionsCode, categoryId, imageId)
	Values("CoffeMug-TRU", "It's a mug from TRU", 5.75, 10, 0, @lastid, null);

