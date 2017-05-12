## Cистема обнаружения и учета открытых сетевых портов KGB (Kit «GhostBusters» – Комплект «Охотники за приведениями»)
### Общие сведения
**KGB** представляет собой **Ruby on Rails** приложение, которое помогает работникам сетевой безопасности контролировать внешние сетевые адреса своей компании.
Такой контроль достигается периодическим, автоматическим сканированием сетевых адресов и сравнением списка легитимных открытых сетевых портов (разрешенных для использования в организации) с результатами сканирования.
Приложение является бесплатным, с открытым исходным кодом и распространяется на условиях лицензии **BSD**.

### Структура приложения
Приложения состоит из следующих частей:
* веб сервер и сервер приложения, работающий поверх фреймворка **Ruby on Rails 4.2**;
* база данных **SQLite 3** (вместо SQLite может быть использована другая СУБД, которая работает с Ruby on Rails);
* утилиты сканирования портов nmap;
* несколько процессов **Delayed Job**, которые периодически извлекают из базы дынных задачи по сканированию и выполняют их;
* **node.js** – серверный движок JavaScript, необходимый отдельным компонентам приложения;
* **foreman** – программа на Ruby для управления запуском компонентов приложения;
* интерпретатор языка **Ruby**, который необходим для работы Ruby on Rails и Delayed Job.

### Установка
Для работы приложения необходимо обеспечить наличие на компьютере компонентов, перечисленных выше.
#### 1.
Установка сканера nmap (здесь и далее по тексту установка пакетов Linux показана на примере Debian\Ubuntu):
```
sudo apt-get install nmap
```
Учетной записи из-под которой будет осуществляться работа приложения (а точнее, будут выполняться фоновые задачи (демоны Delayed Job) по сканированию программой nmap) необходимо дать возможность запуска nmap через sudo без запроса пароля.
Для этого надо выполнить команду 'sudo visudo' и прописать в открывшемся файле (/etc/sudoers) следующую строку (например, для учетной записи kgb):
```
kgb  ALL=NOPASSWD: /usr/bin/nmap
```
#### 2.
Установить Ruby лучше с помощью менеджера **RVM**.
Инструкцию по установке см. на сайте [rvm.io] (http://rvm.io)
>Если в процессе выполнения инструкций сайта RVM не удается импортировать ключи (и соответственно установить RVM), поправить ситуацию можно следующим образом (решения взято с сайта rvm.io):
```
curl -sSL https://rvm.io/mpapis.asc | gpg --import -curl -sSL https://get.rvm.io | bash -s stable
```

#### 3.
После установки RVM устанавливается Ruby (потребуется версия >= 2.3):
```
rvm install 2.3.1
```
Далее необходимо указать RVM использовать установленную версию Ruby 2.3.1 по умолчанию:
```
rvm use --default 2.3.1
```
#### 4.
Теперь можно скачать само приложение KGB (фактически на компьютер будет скопирована папка kgb, в которой находится код программы, для выполнения команды должна быть установлена программа git):
```
git clone https://github.com/atilla777/kgb.git
```
Для установки необходимых приложению библиотек используется пакет Bundle, который необходимо установить:
```
gem bundle install
```
Далее из папки приложения kgb устанавливаются необходимые приложению библиотеки (все последующие действия также выполняются в папке kgb):
```
cd kgb
bundle install
```
#### 5.
Устанавливаем node.js:
```
sudo apt-get install nodejs
```
#### 6.
Создаём таблицы базы данных SQLite – одной командой:
```
RAILS_ENV=production rake db:setup
```
либо следующими двумя командами:
```
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed
```
#### 7.
Устанавливаем gem foreman
```
gem install foreman
```
#### 8.
Компилируем JavaScript, CSS и файлы изображений:
```
bundle exec rake assets:precompile
```
#### 9.
Генерируется секрет, используемый для подписи cookies:
```
bundle exec rake secret
```
сгенерированный секрет прописывается в файле ==.env== как переменная окружения (откуда он потом будет подставляться в config/secrets.yml):
```
SECRET_KEY=секрет
```
#### 10.
Создание самоподписанного сертификата для веб сервера (требуется установленная программы openssl):
```
openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 1000 -nodes
```
#### 11.
Добавление пользователя из под которого будет запускаться приложение при старте ОС (если выполнить foreman export):
```
useradd -r kgb
```
Назначение пользователю kgb прав на каталог kgb:
```
sudo chown -R kgb kgb 
```
### Запуск
```
rvmsudo foreman start -m web=1,planner_worker=1,now_scan_worker=7,planned_scan_worker=5
```
При этом надо учитывать, что режим в котором запустится приложение задан в переменной окружения RAILS_ENV, указанной в файле ==env== (по умолчанию - запускать приложение в рабочем режиме, т.е. production).
После выполнения указанной выше команды будут запущены:
* 1 процесс web – для rails приложения (веб сервер);

и следующие фоновые процессы Delayed Job:
* 1 процесс planner_worker – планировщик для ежедневного планирования работ, которые должны запуститься в этот день.
* 7 процессов now_scan_worker – для выполнения сканирований по требованию пользователя (количество процессов можно изменить, при этом должен быть как минимум 1);
* 5 процессов planned_scan_worker – для выполнения запланированных планировщиком работ по сканированию (количество процессов можно изменить, при этом должен быть как минимум 1).
Задать количество запускаемых процессов ==now_scan_worker== и ==planned_scan_worker==, а также организовать их запуск через стартовые сценарии ОС, можно (и рекомендуется) выполнив следующую команду (для systemd):
```
vmsudo foreman export systemd /etc/systemd/system -a kgb -u kgb -m web=1,planner_worker=1,now_scan_worker=7,planned_scan_worker=5
```
> Указанная выше команда может отработать некорретно, поэтому необходимо проверить сгенерированные ею файлы и внести в них необходимые корректировки. В частности необходимо проверить описание следующих сервисов ==systemd== (папка /etc/systemd):
* kgb-web@.service
* kgb-planner_worker@.service
* kgb-now_scan_worker@.service
* kgb-planned_scan_worker@.service
Файл ==kgb-web@.service== должен иметь следующий вид:
```
[Unit]
PartOf=kgb-web.target

[Service]
User=kgb
WorkingDirectory=/home/kgb/kgb
Environment="PATH=/home/пользователь/.rvm/gems/ruby-2.3.1/bin:/home/пользователь/.rvm/gems/ruby-2.3.1@global/bin:/home/пользователь/.rvm/rubies/ruby-2.3.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/пользователь/.rvm/bin:/home/пользователь/.rvm/bin:/home/пользователь/.rvm/bin"
Environment="GEM_HOME=/home/пользователь/.rvm/gems/ruby-2.3.1"
Environment="GEM_PATH=/home/пользователь/.rvm/gems/ruby-2.3.1:/home/пользователь/.rvm/gems/ruby-2.3.1@global"
EnvironmentFile=/home/kgb/kgb/.env
ExecStart=/bin/bash -lc '/usr/bin/authbind --deep bundle exec puma'
Restart=always
StandardInput=null
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=%n
KillMode=mixed
TimeoutStopSec=5
```
Остальныедолжны выглядить так (на примере kgb-now_scan_worker@.service):
```
[Unit]
PartOf=kgb-now_scan_worker.target

[Service]
User=kgb
WorkingDirectory=/home/kgb/kgb
Environment="PATH=/home/пользователь/.rvm/gems/ruby-2.3.1/bin:/home/пользователь/.rvm/gems/ruby-2.3.1@global/bin:/home/пользователь/.rvm/rubies/ruby-2.3.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/пользователь/.rvm/bin:/home/пользователь/.rvm/bin:/home/пользователь/.rvm/bin"
Environment="GEM_HOME=/home/alexy/.rvm/gems/ruby-2.3.1"
Environment="GEM_PATH=/home/alexy/.rvm/gems/ruby-2.3.1:/home/alexy/.rvm/gems/ruby-2.3.1@global"
Environment="QUEUE=now_scan"
EnvironmentFile=/home/kgb/kgb/.env
ExecStart=/bin/bash -lc 'bundle exec rake jobs:work'
Restart=alway
StandardInput=null
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=%n
KillMode=mixed
TimeoutStopSec=5
```
После чего управление запуском приложения сведется к выполнению следующих команд Linux:
```
systemctl start kgb.target
systemctl stop kgb.target
systemctl restart kgb.target
```
Для того, что бы приложение запускалось при старте ОС:
```
sudo systemctl enable kgb.target
```
Если необходимо запустить приложение на привелегированных портах (например, 443) можно воспользоваться пакетом ==authbind==.
Для этого вначале нужно внести изменения в находящийся в корневой папке приложения файл .env, сменив в нем значение переменной окружения SSL_PORT:
```
SSL_PORT=443
```
Затем необходимо выполнить следующие команды (в примере приложение запускается из под непривилегированной учетной записи kgb):
```
sudo apt-get install authbind
sudo touch /etc/authbind/byport/443
sudo chown kgb /etc/authbind/byport/443
sudo chmod 500 /etc/authbind/byport/443
```
В файле kgb-web@.service должна быть такая строка:
```
ExecStart=/bin/bash -lc '/usr/bin/authbind --deep bundle exec puma'
```
#### Запуск приложения (вариант 2, можно использовать, например, при отладке)
запускаем веб приложение:
```
rails s -e pruduction
```
запускаем вспомогательные процессы планирования\выполнения сканирований в фоне:
```
RAILS_ENV=production bin/delayed_job --queue=planner start
RAILS_ENV=production bin/delayed_job --queue=now_scan start
RAILS_ENV=production bin/delayed_job --queue=planned_scan start
```
Процесс планирования\выполнения сканирования можно запустить следующим образом (не в фоне, например, для отладки):
```
QUEUE=planner RAILS_ENV=production bundle exec rake jobs:work
QUEUE=now_scan RAILS_ENV=production bundle exec rake jobs:work
QUEUE= planned_scan RAILS_ENV=production bundle exec rake jobs:work
```
### Использование
Запускаем браузер и переходим по ссылке
```
https://localhost:3001
```
Логин для входа:
```
kgb@ussr.su
```
Пароль:
```
smersh
```
#### Термины, используемые в приложении:
* Работа – совокупность хоста (хостов), его (их) порта (портов), опций сканирования и дней недели, являющиеся настройками, с которыми будет выполняться работа по сканированию;
* Хост – IP4 адрес сканируемого компьютера;
* Сервис – совокупность хоста и его порта;
* Работающий (активный) сревис – сервис с открытым сетевым портом;
* Легитимность – свойства сервиса, говорящее о том должен сервис быть работающим или нет с точки зрения собственного учета организации;
* Опция сканирования – набор опций nmap, с которыми будет выполняться работа;
* Задача – запланированная (ждущая своего выполнения в фоне) работа по сканированию или выполняющаяся работа (перечень задач доступен только для администратора в меню «Обслуживание»).

В меню «Справочники» создаются:
* перечень сканируемых хостов;
* сервисы, порты которых будут контролироваться с помощью приложения;
* опции сканирования;
* работы по сканированию.

При создании работы выбираются опции сканирования, указывается IP адрес (можно указать и диапазон) или доменное имя контролируемого сервера, проверяемый порт или порты (порты указываются через запятую, вместо числа можно указывать диапазон-начальное и конечное значение). Для созданной работы можно указать дни недели, по которым она будет выполняться.
Примеры задания в работе IP адресов и номеров портов:
```
IP адреса хостов:
www.test.ru
192.168.1.1
192.168.1.0-20
92.168.1.1-244
192.168.1.*
```
номера портов:
```
80
21, 80, 3000
21, 80-443, 3000
```
После создания работы ее можно запустить, кликнув по значку лупы.
После завершения сканирования, его результаты можно посмотреть в меню «Результаты сканирования».
Если в результате выполнения работ были обнаружены открытые порты у зарегистрированных в приложении сервисов, информацию о них, можно будет увидеть в меню «Активные сервисы».
Если в результате выполнения работ были обнаружены открытые порты у зарегистрированных в приложении хостов и для таких сочетаний хостов и портов в программе нет созданных сервисов, информацию о них, можно будет увидеть в меню «Новые сервисы».
#### Рекомендуется следующий сценарий использования программы:
1. создать интересующие хосты;
2. определить опцию сканирования, позволяющую определить, какие порты открыты (-sS, -pN, -sU,  --top-ports=1000);
3. создать работы с указанными выше хостами и опцией, равномерно распределив их по дням недели;
4. через меню новые «Новые сервисы», зарегистрировать найденные сервисы (как легитимные или нелегитимные);
5. периодически просматривать меню «Новые сервисы» и «Активные сервисы», для выявления изменения.
