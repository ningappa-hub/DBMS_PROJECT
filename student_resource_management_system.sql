use student_resource_management_system;

-- Create the database
create database fest_management;

-- Use the database
use fest_management;

-- Create the tables
create table Fest (
    Fest_ID varchar(5) primary key,
    Fest_Name varchar(100) unique not null,
    Year year,
    Head_Team_ID varchar(5) unique
);


create table Team (
    Team_ID varchar(5) primary key,
    Team_Name varchar(100) unique not null,
    Team_Type enum('ORG', 'MNG') default 'ORG',
    Fest_ID varchar(5)
);

alter table Fest add foreign key (Head_Team_ID) references Team(Team_ID);
alter table Team add foreign key (Fest_ID) references Fest(Fest_ID);

create table Member (
    Member_ID varchar(5) primary key,
    Member_Name varchar(100) not null,
    Date_of_Birth date,
    Supervisor_Member_ID varchar(5),
    Team_ID varchar(5)
);

describe Member;

alter table Member add foreign key (Supervisor_Member_ID) references Member(Member_ID);
alter table Member add foreign key (Team_ID) references Team(Team_ID);

create table Event (
    Event_ID varchar(5) primary key,
    Event_Name varchar(25) not null,
    Building varchar(15),
    Floor varchar(10),
    Room_Number integer,
    Price decimal(10, 2) check (Price < 1500.00),
    Team_ID varchar(5)
);

alter table Event add foreign key (Team_ID) references Team(Team_ID);

create table Event_Conduction (
    Event_ID varchar(5),
    Date_of_Conduction date,
    primary key (Event_ID, Date_of_Conduction),
    foreign key (Event_ID) references Event(Event_ID)
);

create table Participant (
    SRN varchar(10) primary key,
    Name varchar(25) not null,
    Department varchar(20),
    Semester integer,
    Gender enum('Male', 'Female')
);

create table Visitor (
    SRN varchar(10),
    Name varchar(25) not null,
    Age integer,
    Gender enum('Male', 'Female'),
    primary key (SRN, Name)
);

create table Registration (
    Event_ID varchar(5),
    SRN varchar(10),
    Registration_ID varchar(5) not null,
    primary key (Event_ID, SRN),
    foreign key (Event_ID) references Event(Event_ID),
    foreign key (SRN) references Participant(SRN)
);

create table Stall (
    Stall_ID varchar(5) primary key,
    Name varchar(25) unique not null,
    Fest_ID varchar(5),
    foreign key (Fest_ID) references Fest(Fest_ID)
);

create table Item (
    Item_ID varchar(5) primary key,
    Name varchar(100) not null,
    Type enum('Veg', 'Non-Veg') not null
);

alter table Item add INDEX idx_item_name (Name);

create table Stall_Items (
    Stall_ID varchar(5),
    Item_Name varchar(25) not null,
    Price_Per_Unit decimal default 50 not null,
    Total_Quantity int check (Total_Quantity <= 150),
    primary key (Stall_ID, Item_Name),
    foreign key (Stall_ID) references Stall(Stall_ID),
    foreign key (Item_Name) references Item(Item_ID)
);

ALTER TABLE Stall_Items 
DROP FOREIGN KEY stall_items_ibfk_2;  -- Assuming this is the name of the foreign key constraint.

ALTER TABLE Stall_Items 
CHANGE COLUMN Item_Name Item_ID VARCHAR(5);  -- Update column name and set its type to match `Item_ID` type.


ALTER TABLE Stall_Items 
ADD CONSTRAINT fk_item_id FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID);

ALTER TABLE Stall_Items
MODIFY Price_Per_Unit DECIMAL(10,2);



create table Purchased (
    SRN varchar(10),
    Stall_ID varchar(5),
    Item_Name varchar(25),
    Timestamp timestamp,
    Quantity INT NOT NULL,
    primary key (SRN, Stall_ID, Item_Name, Timestamp),
    foreign key (SRN) references Participant(SRN),
    foreign key (Stall_ID) references Stall(Stall_ID),
    foreign key (Item_Name) references Item(Name)
);
