drop table SelectsPrize;

drop table StoresProduct;

drop table Prize;

drop table DegreeOrder;

drop table Comment;

drop table Review;

drop table OrderedProduct;

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
totalCost decimal(8,2),
pointsEarned int,
accountId int not null,
foreign key(accountId) References Customer(accountId)
	on update cascade
);

Create Table Shipment(
shipmentId int primary key auto_increment,
shipped Date,
recieved Date,
readyToShip boolean default false not null,
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

Create Table OrderedProduct(
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
	on update cascade on delete cascade
);
Insert Into ProductCategory(catName, description, imageId)
	Values("Hoodies", "Keep you nice and warm!", null);
SET @lastid = LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("SFU Hoodie", "Sport this SFU hoodie, and trick everyone into thinking you're an alumn!", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UBC Sweatshirt", "Not just the classic blue and yellow, this niche UBC sweatshirt will have people thinking you really made it to the store!", 45.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("TRU Hoodie", "Who are we kidding? Nobody would lie about going to TRU. But just in case, this hoodie will drive the point home!", 30.25, 500, @lastid, null);
	
Insert Into ProductCategory(catName, description, imageId)
	Values("Drinkware", "Decorate your drinks as though you earned your degree", null);
SET @lastid =  LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UVIC Mug", "What do people even drink out in Victoria? You should probably check before ordering this mug.", 5.75, 10, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("SFU Mug", "With this on your desk, your boss will be sure you actually attended SFU.", 5.75, 10, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UBC Mug", "Can't you remember all the coffee you drank, up late, studying for exams? Of course you don't!", 35.75, 500, @lastid, null);
	
Insert Into ProductCategory(catName, description, imageId)
	Values("Sports Wear", "Everyone says sports are a part of the University experience. Support your so-called 'school team'!", null);
SET @lastid = LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UVIC Vikes Shirt", "An interesting brand deal with Nike they've got going on out there at UVIC!", 40.50, 500, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("SFU Sport Shirt", "They couldn't even come up with a team name! It's a good thing you decided not to go to SFU.", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UBC Thunderbirds Shirt", "The crowds, the cheering, the sports! All thing you definitely experience at UBC!", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("TRU Wolfpack Shirt", "You were one of the pack. Your shirt even says so!", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UVIC Tee", "This slick will make people think you really attended the University of Victoria!", 40.50, 500, @lastid, null);	
	
Insert Into ProductCategory(catName, description, imageId)
	Values("Gear", "Stuff you 'definitely' kept your notes in back in your University days", null);
SET @lastid = LAST_INSERT_ID();
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UVIC Binder", "It never held any actual notes, but nobody has to know that.", 40.50, 500, @lastid, null);	
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("SFU Notebook", "This is official SFU standard! Just don't let anyone read it.", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("UBC Planner", "You probably would have kept track of all your classes in this! If you'd attended, of course.", 35.75, 500, @lastid, null);
Insert Into Product(pname, description, price, pointValue, categoryId, imageId)
	Values("TRU Lab Book", "Labs can be long and gruelling. Aren't you glad you didn't have to do any?", 35.75, 500, @lastid, null);

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
Insert Into University(name, description, imageId)
	Values("SFU", "Another University located in Vancouver", null);
Insert Into University(name, description, imageId)
	Values("TRU", "A University located in Kamloops", null);
Insert Into University(name, description, imageId)
	Values("UVIC", "A University located in Victoria", null);

Insert Into Account
(loginName, password, creationDate, LastLogin, cname, email, isDeactivated)
Values("guest", "5sPaWyBmNNfz81htdH/9s2tcZ1dXs4DGpf5cVwxxQ0k=", DATE('2017-11-19'), DATE('2017-11-19'), "guest", "guest@email.com", false);
SET @lastid = LAST_INSERT_ID();
Insert Into Customer(accountId, prizePoints, isWarned, isBanned)
Values(@lastid, 0, false, false);
Insert Into Address(typCode, street, city, postalCode, accountId)
Values(0, "1245 Guest Street NW", "Kelowna", "G1Y4R3", @lastid);
SET @lastid = LAST_INSERT_ID();

Insert Into Address(addressId , street, city, postalCode, accountId)
	Values(0, "1245 Guest Street NW", "Kelowna", "G1Y4R3", @lastid);

Insert Into Warehouse(warehouseId, street, city, postalCode)
	Values(1, "1914 Fake Street", "Kelowna", "R4W7Q1");

Insert Into Warehouse(warehouseId, street, city, postalCode)
	Values(2, "1939 Real Boulevard", "Prince George", "A8C1T4");

Insert Into Warehouse(warehouseId, street, city, postalCode)
	Values(3, "2765 Indeterminate Avenue", "Vancouver", "Y7S2V8");

select @prodId := productId From Product Where pname ="SFU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 10);

select @prodId := productId From Product Where pname ="SFU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 10);
	
select @prodId := productId From Product Where pname ="SFU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 20);

select @prodId := productId From Product Where pname ="SFU Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 10);

select @prodId := productId From Product Where pname ="SFU Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 5);
	
select @prodId := productId From Product Where pname ="SFU Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 15);
	
select @prodId := productId From Product Where pname ="SFU Sport Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 5);
	
select @prodId := productId From Product Where pname ="SFU Sport Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 10);
	
select @prodId := productId From Product Where pname ="SFU Sport Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 25);
	
select @prodId := productId From Product Where pname ="SFU Notebook";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 40);
	
select @prodId := productId From Product Where pname ="TRU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 10);
	
select @prodId := productId From Product Where pname ="TRU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 20);
	
select @prodId := productId From Product Where pname ="TRU Hoodie";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 5);
	
select @prodId := productId From Product Where pname ="TRU Lab Book";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 20);
	
select @prodId := productId From Product Where pname ="TRU Wolfpack Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 30);
	
select @prodId := productId From Product Where pname ="TRU Wolfpack Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 10);
	
select @prodId := productId From Product Where pname ="TRU Wolfpack Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 5);
	
select @prodId := productId From Product Where pname ="UBC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 30);
		
select @prodId := productId From Product Where pname ="UBC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 20);
		
select @prodId := productId From Product Where pname ="UBC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 50);
		
select @prodId := productId From Product Where pname ="UBC Planner";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 25);
		
select @prodId := productId From Product Where pname ="UBC Planner";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 50);
		
select @prodId := productId From Product Where pname ="UBC Thunderbirds Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 20);
			
select @prodId := productId From Product Where pname ="UBC Thunderbirds Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 5);
			
select @prodId := productId From Product Where pname ="UBC Thunderbirds Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 50);
			
select @prodId := productId From Product Where pname ="UBC Sweatshirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 35);
				
select @prodId := productId From Product Where pname ="UBC Sweatshirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 10);
				
select @prodId := productId From Product Where pname ="UBC Sweatshirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 60);
				
select @prodId := productId From Product Where pname ="UVIC Binder";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 30);
					
select @prodId := productId From Product Where pname ="UVIC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 15);
						
select @prodId := productId From Product Where pname ="UVIC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 10);
						
select @prodId := productId From Product Where pname ="UVIC Mug";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 25);
						
select @prodId := productId From Product Where pname ="UVIC Vikes Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 10);
							
select @prodId := productId From Product Where pname ="UVIC Vikes Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 5);
							
select @prodId := productId From Product Where pname ="UVIC Vikes Shirt";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 30);
							
select @prodId := productId From Product Where pname ="UVIC Tee";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(1, @prodId, 30);
	
select @prodId := productId From Product Where pname ="UVIC Tee";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(2, @prodId, 20);
								
select @prodId := productId From Product Where pname ="UVIC Tee";  
Insert Into StoresProduct(warehouseId, productId, amount)
	Values(3, @prodId, 45);
	
select @prodId := productId From Product Where pname="SFU Hoodie";
select @accountId := accountId From Account Where loginName="guest";
Insert Into Review( description, rating, accountId, productId)
Values("People really think I went there! Great Product!", 4,1 , @prodId);

select @prodId := productId From Product Where pname="UVIC Tee";
select @accountId := accountId From Account Where loginName="guest";
Insert Into Review( description, rating, accountId, productId)
Values("Good product, bad University.", 2,1, @prodId); 

Insert Into Account
(loginName, password, creationDate, LastLogin, cname, email, isDeactivated,adminLevel)
Values("beans", "5sPaWyBmNNfz81htdH/9s2tcZ1dXs4DGpf5cVwxxQ0k=", DATE('2017-11-19'), DATE('2017-11-19'), "bean", "guest@email.com", false,1);
SET @lastid = LAST_INSERT_ID();
Insert Into Customer(accountId, prizePoints, isWarned, isBanned)
Values(@lastid, 0, false, false);
Insert Into Address(typCode, street, city, postalCode, accountId)
Values(0, "1245 Guest Street NW", "Kelowna", "G1Y4R3", @lastid);

