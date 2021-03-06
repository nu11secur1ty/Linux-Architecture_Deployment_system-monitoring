![](https://github.com/nu11secur1ty/OpenSUSE-Linux-Linux-Architecture_Deployment-administration/blob/master/Mysql/InnoDB%20and%20MyISAM/screen/mysql_PNG31.png)


# Storage Engines в MySQL и основните разлики между тях.

-------------------------------------------------------------------------

# Какво представлява Storage Engine?

Storage Engine е основния компонент, който системите за управление на бази данни (СУБД) използват, за да създават, четат, актуализират и изтриват данни от база данни. Когато използвате Storage Engine можете да изберете той да се използва за целия сървър, за отделна база данни или за определена таблица. По подразбиране MySQL има Storage Engines за съхранение на данни, които са предварително конфигурирани и се поддържат от MySQL сървъра.

# Указване на Storage Engine

В MySQL, при заявка за създаване на таблица, има възможност да се укаже Storage Engine. Ако не бъде указан, тогава ще се ползва Storage Engine, който е зададен по подразбиране за MySQL сървъра.

В най-общия случай, заявката за създаване на таблица с указване на Storage Engine е следната:

```mysql
CREATE TABLE table_name(
create_definition, ...
) ENGINE [=] storage_engine;
```
където storage_engine може да бъде MyISAM, InnoDB, Memory и т.н.

Различните Storage Engines, с които разполага MySQL са проектирани за употреба в различни случаи. За да използвате компонента ефективно е добре да имате представа за предимствата и недостатъците на различните видове Storage Engines. Така можете да увеличите скоростта и да подобрите цялостната функционалност на вашето приложение.

# `Кои са най-често използваните Storage Engines и какви са основните разлики между тях:`

Най-често използваните Storage Engines, които разбира се, можете да използвате и на нашите сървъри са `MyISAM`, `InnoDB`, `Memory`.

- Ето и основните разлики между трите Engine-а:


**MyISAM** `не е транзакционен Engine`, т.е. не може да се оптимизира процеса на обработка на транзакции. `InnoDB за сравнение е транзакционен;`
- При заявки към базата данни (select, update и др.) `при MyISAM се заключва цялата таблица (table-level locking)` и не може да се чете и пише в нея, докато не се обработи заявката, която е заключила таблицата. Реално тази функционалност не е нужно да се приема като недостатък. Заключването и отключването на таблицата е много бърз процес и ако заявките са оптимизирани добре и се изпълняват много бързо, то може да се изпълнят няколко хиляди заявки в една секунда без проблем.При `InnoDB заключването по време на заявки е на ниво ред от таблицата (row-level locking)`. По този начин, по едно и също време, могат да се изпълнят няколко заявки към базата;
   
- `При crash или неочаквано прекъсване` в InnoDB се прави сканиране на транзакционните логове и недовършените транзакции се rollback-ват в базата. Завършените, но не отразени в data-файловете на самата база транзакции се прилагат, с което се завършва процеса на възстановяване.При MyISAM в такива случаи се налага пълно сканиране на таблицата и съответно нейната поправка при проблем с консистенцията на данните. Поради тази причина, при `възстановяване от crash, InnoDB е с по-голямо бързодействие` при увеличаване обема на базата данни, тъй като при възстановяване на InnoDB не се сканира цялата таблица, а само се прилагат транзакционните логове. При MyISAM за сравнение времето за проверка расте с увеличаване размера на файловете;
- За уеб приложения MyISAM е все още широко използван, тъй като традиционно се възприема като по-бързо, отколкото InnoDB в ситуации, когато базата най-често се използва за четене. Все пак трябва да се има в предвид, че има различни типове натоварвания на базата. Не може да се каже, че единият е по-добър, по-бърз и съответно по-подходящ от другия във всички ситуации. `И двата Engine-а си имат предимства и недостатъци и са подходящи при различни случаи.`

Относно производителността на базата данни можем `да споделим от практиката ни различни примери`, като няма универсално решение и в зависимост от приложението, е по-подходящо да се използва MyISAM или InnoDB.

`Ето и един от последните примери, които можем да споделим:`

***Разглеждаме клиентско приложение със сравнително бавна заявка (изпълняваща се за 400-500 ms) и MyISAM. При няколко паралелни заявки, поради дългото изпълнение на заявката, таблицата стоеше заключена около 0.5сек и `заявките се изчакваха една друга, за да могат да се изпълнят`. Проблемът се влошаваше още повече от факта, че имаше и други заявки, които се опитваха да правят UPDATE и INSERT в същата таблица.***

Тук, променяйки `Storage Engine-a на InnoDB повишихме многократно скоростта на изпълнение`, тъй като вече не стоеше заключена цялата таблица. Това, разбира се, е само пример. Има много други случаи, в които MyISAM може да е по-оптимален за работа, но преди всичко трябва да се тества.

**Ще се радваме и вие да споделите още разлики, предимства или недостатъци на MyISAM, в сравнение с InnoDB, както и примери за производителността на Engine-ите!**

При **Memory Storage Engine-a** (или както е познат като Heap Engine) основната разлика от другите два е, че `запазва данните в RAM паметта`. Това осигурява голямо бързодействие, но крие и риска, `че при рестарт на MySQL-а` при предвидени или непредвидени обстоятелства :), `се губи информация`. Подходящ е да се използва при собствени кеширащи алгоритми, като в Memory Storage Engine-a да се пазят временни таблици с кеширани данни, които при загубата, могат да се възстановят от реалните. Този начин на кеширане, обаче, е сравнително слабо разпространен и при такива ситуации обикновено се използва memcache.

**`Защо да използвате ENGINE, а не TYPE?`**

При посочването на Storage Engine, освен ENGINE, доста често все още се използва TYPE (особено в по-старите версии на някои готови CMS системи), като двете опции са синоними.

**`Опцията TYPE e deprecated в MySQL 4.0, а в MySQL 5.5 е преустановено нейното използване. Поради тази причина, при опит за създаване на таблица на сървър с MySQL 5.5 и използване на TYPE, SQL заявката няма да се изпълни успешно.`**

# Какво съобщение за грешка може да получите?

При използване на TYPE за указване на Storage Engine в `MySQL` 5.5 `се получава грешка в SQL синтаксиса`. В зависимост от посочения Storage Engine (например MyISAM или InnoDB) ще се получи съобщение за грешка, подобно на следното:

```mysql
You have an error in your SQL syntax; check the manual that corresponds
to your MySQL server version for the right syntax to use near
'TYPE = MyISAM ... '
```
или

```mysql
You have an error in your SQL syntax; check the manual that corresponds
to your MySQL server version for the right syntax to use near
'TYPE = InnoDB ... '
```
**Съвети от support-а:**
1. Ако вашето приложение е разположено на сървър с `MySQL` 5.5 и нагоре, `се уверете, че използвате ENGINE в заявките за създаване на таблици`. Ако вече разполагате с .SQL файл, който ще импортирате, можете да го отворите за редакция и `да заместите навсякъде TYPE с ENGINE`;

2. При разработка на приложение, дори и версията на `MySQL` да е по-ниска от 5.5, препоръчваме ви `винаги да указвате Storage Engine с опцията ENGINE`. По този начин ще избегнете проблем с несъвместимостта във версиите в бъдеще;

3. Няма универсално решение кой Storage Engine да изберете. В зависимост от приложението, може да е по-подходящо да се използва MyISAM, InnoDB или друг. Важно е `да тествате, за да разберете кое е най-оптималното за вас решение`.


# СуперХостинг.БГ





