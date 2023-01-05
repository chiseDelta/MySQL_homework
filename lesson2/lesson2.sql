use chisedatabase;

# 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select *
from users
where length(name) >= 6;

# 2.Вибрати львівські відділення банку.
select *
from department
where DepartmentCity = 'Lviv';

# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select *
from client
where Education = 'high'
order by LastName;

# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select *
from application
order by idApplication desc
limit 5;

# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select *
from client
where LastName like '%iv'
   or LastName like '%a';

# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select idClient, FirstName, LastName, DepartmentCity
from client
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Kyiv';

# 7.Знайти унікальні імена клієнтів.
# insert into client values (11, 'Oleg', 'Fedychkanych', 'high', 'KC723523', 'Lviv', 23, 5);
select distinct FirstName
from client;

# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.
select idClient,
       FirstName,
       LastName,
       Passport,
       City,
       Age,
       idApplication,
       CreditState,
       Sum
from client
         join application a on client.idClient = a.Client_idClient
where Currency = 'Gryvnia';

# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(*) as all_lviv
from client
         join department d on d.idDepartment = client.Department_idDepartment
union
select count(*)
from client
         join department d2 on d2.idDepartment = client.Department_idDepartment
where DepartmentCity = 'lviv';

# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select max(Sum) as max_credit, client.*
from client
         join application a on client.idClient = a.Client_idClient
group by idClient, FirstName, LastName;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select count(*) as credit_count, idClient, FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
group by idClient, FirstName, LastName;

# 12. Визначити найбільший та найменший кредити.
select min(Sum) as min_sum, max(Sum) as max_sum
from application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(*), idClient, FirstName, LastName, Education
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high'
group by idClient, FirstName, LastName, Education;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select avg(Sum) as avg, client.*
from client
         join application a on client.idClient = a.Client_idClient
group by idClient
order by avg desc
limit 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
select sum(Sum) as sum, idDepartment, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by DepartmentCity, idDepartment
order by sum desc
limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.
select max(Sum) as max_sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by idDepartment
order by max_sum desc
limit 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application join client c on c.idClient = application.Client_idClient
set Sum=6000
where Education = 'high';

# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client join department d on d.idDepartment = client.Department_idDepartment
set City='Kyiv'
where DepartmentCity = 'kyiv';

# 19. Видалити усі кредити, які є повернені.
delete application
from application
where CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete application
from application
         join client c on c.idClient = application.Client_idClient
where LastName like '_e%'
   or LastName like '_y%'
   or LastName like '_u%'
   or LastName like '_o%'
   or LastName like '_a%';

# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select sum(Sum) as sum, DepartmentCity, idDepartment
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'lviv'
group by idDepartment, DepartmentCity
having sum(Sum) > 5000;

# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select idClient, FirstName, LastName, CreditState, Sum
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'Returned'
  and Sum > 5000;

# 23.Знайти максимальний неповернений кредит.
# select max(Sum) as max_credit, idClient, FirstName, LastName, CreditState, Currency
# from client
#          join application a on client.idClient = a.Client_idClient
# where CreditState = 'Not returned'
# group by idClient, FirstName, LastName, CreditState, Currency
# order by max_credit desc
# limit 1;
# ------------------------------------------ OR ----------------------------------------
select application.*
from application
where CreditState = 'Not returned'
order by Sum desc
limit 1;

# 24.Знайти клієнта, сума кредиту якого найменша
select idClient,
       FirstName,
       LastName,
       Age,
       idApplication,
       Sum,
       CreditState,
       Currency
from client
         join application a on client.idClient = a.Client_idClient
order by Sum
limit 1;

# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
select *
from application
where Sum > (select avg(Sum) as avg from application);

# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select *
from client
where City = (select c.City
              from client c
                       join application a on c.idclient = a.client_idclient
              group by idclient
              order by count(idApplication) desc
              limit 1);

# 27. Місто клієнта з найбільшою кількістю кредитів
select c.City
from client c
         join application a on c.idclient = a.client_idclient
group by idclient
order by count(idapplication) desc
limit 1;