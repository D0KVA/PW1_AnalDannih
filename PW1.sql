CREATE DATABASE DATA_ANALYTICS_PW1;
GO
USE DATA_ANALYTICS_PW1;
GO

CREATE TABLE Roles
(
	ID_Role INT PRIMARY KEY IDENTITY(1,1),
	NameRole VARCHAR(45)
);

INSERT INTO Roles (NameRole)
VALUES
	('����������'),
	('��������');
GO

CREATE TABLE Clients
(
	ID_Client INT PRIMARY KEY IDENTITY(1,1),
	NameClient VARCHAR(45),
	LoginClient VARCHAR(45) NOT NULL,
	Role_ID INT NOT NULL,
	MoneyInAccount INT,
	FOREIGN KEY (Role_ID) REFERENCES Roles(ID_Role)
);

INSERT INTO Clients (NameClient, LoginClient, Role_ID, MoneyInAccount)
VALUES
	('���������', 'DOKVA', 1, 2300),
	('������', 'CUPSIZE', 2, 50000),
	('�������', 'astrakiddy', 1, 5000),
	('�����', 'GodSharp', 2, 1984),
	('�������', 'RamDOG', 1, 2000);
GO

CREATE TABLE ItemTypes(
    ID_ItemType INT PRIMARY KEY IDENTITY(1,1),
    NameType VARCHAR(45) UNIQUE NOT NULL,
	DescriptionType TEXT
);

INSERT INTO ItemTypes (NameType, DescriptionType)
VALUES
	('������� �������', '�������� ���������� ��� ���� ��� �� ������ ����������� ���� ��� ����'),
	('������� � ��������', '�������� ���������� ��� �������, ������� � ������ ����.'),
	('���������', '��������� ��������, ����������� ����������������� ������ ����������. ����� ������������� � ���������� ��������� ������������ ����������, ����������� ����������������� ���������� ��������.'),
	('���� � ������', '������ ��� ��������� ���������, ������, ������ � ����, ��� ������ ��������� ���� � ����� �������.'),
	('������� ������������', '����������, ����������� ��� ������ ������������ ����.');
GO

CREATE TABLE Items(
    ID_Item INT PRIMARY KEY IDENTITY(1,1),
    NameItem VARCHAR(25) NOT NULL,
	PriceItem DECIMAL(10,2) NOT NULL,
	ItemType_ID INT NOT NULL,
	FOREIGN KEY (ItemType_ID) REFERENCES ItemTypes(ID_ItemType)
);

INSERT INTO Items (NameItem, PriceItem, ItemType_ID)
VALUES
	('��� DADAYASIN', 5000.00, 2),
	('POKO X3 TURBO ZXC EZHKERE', 15000.00, 3),
	('���� �������, �������', 1000.00, 4),
	('WI-FI ������ DARKHOLE', 4000.00, 5),
	('���� BIBAED', 20000.00, 1);
GO

CREATE TABLE Orders(
    ID_Order INT PRIMARY KEY IDENTITY(1,1),
    DateOrder DATE NOT NULL,
    Client_ID INT NOT NULL,
    FOREIGN KEY (Client_ID) REFERENCES Clients(ID_Client)
);

INSERT INTO Orders (DateOrder, Client_ID)
VALUES
	('2024-09-01', 1),
	('2024-09-05', 3),
	('2023-05-12', 3),
	('2022-12-23', 5),
	('2024-02-17', 1);
GO

CREATE TABLE OrderItems (
    ID_OrderItem INT PRIMARY KEY IDENTITY(1,1),
    Order_ID INT NOT NULL,
    Item_ID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Orders(ID_Order),
    FOREIGN KEY (Item_ID) REFERENCES Items(ID_Item)
);

INSERT INTO OrderItems (Order_ID, Item_ID, Quantity)
VALUES
	(1, 1, 2),
	(2, 2, 1),
	(3, 3, 2),
	(5, 5, 4),
	(4, 1, 3);
GO



--����� ������� ������������� �������
SELECT Orders.ID_Order, Orders.DateOrder, Clients.NameClient, Clients.LoginClient
FROM Orders JOIN Clients ON Orders.Client_ID = Clients.ID_Client
WHERE Clients.NameClient = '���������'
ORDER BY Orders.DateOrder;
--����� ������� ������������� �������

--������� ���������� ������� �� ��������
	SELECT Clients.NameClient, COUNT(Orders.ID_Order) AS OrderCount
	FROM  Clients
	LEFT JOIN Orders ON Clients.ID_Client = Orders.Client_ID
	GROUP BY Clients.NameClient
	HAVING COUNT(Orders.ID_Order) > 1;
--������� ���������� ������� �� ��������

--����� ���������� ����� ���������, ���������� ���������
SELECT DISTINCT Items.NameItem
FROM Items
JOIN OrderItems ON Items.ID_Item = OrderItems.Item_ID
JOIN Orders ON OrderItems.Order_ID = Orders.ID_Order
WHERE Items.NameItem LIKE '%�%';
--����� ���������� ����� ���������, ���������� ���������


--���������� �������
SELECT COUNT(ID_Order) AS TotalOrders
FROM Orders;

SELECT SUM(Items.PriceItem * OrderItems.Quantity) AS TotalOrderValue
FROM OrderItems
JOIN Items ON OrderItems.Item_ID = Items.ID_Item;

SELECT MAX(Items.PriceItem * OrderItems.Quantity) AS MaxOrderValue
FROM OrderItems
JOIN Items ON OrderItems.Item_ID = Items.ID_Item;

SELECT MIN(Items.PriceItem * OrderItems.Quantity) AS MaxOrderValue
FROM OrderItems
JOIN Items ON OrderItems.Item_ID = Items.ID_Item;

SELECT AVG(Items.PriceItem * OrderItems.Quantity) AS AverageOrderValue
FROM OrderItems
JOIN Items ON OrderItems.Item_ID = Items.ID_Item;
--���������� �������


--��������� �������
SELECT Orders.ID_Order, 
       Orders.DateOrder, 
       Clients.NameClient,
       SUM(Items.PriceItem * OrderItems.Quantity) OVER ()  AS TotalOrderValue
FROM Orders
JOIN OrderItems ON Orders.ID_Order = OrderItems.Order_ID
JOIN Items ON OrderItems.Item_ID = Items.ID_Item
JOIN Clients ON Orders.Client_ID = Clients.ID_Client
--��������� �������