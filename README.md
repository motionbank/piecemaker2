piecemaker API
==============

Execute ```node index.js``` (see also [nodemon](https://github.com/remy/nodemon)).

Delete all data in all tables and insert dummy data, execute ```node test/db_dummy_data.js```


Example DB
----------
__Use this DB for example datasets.__
* https://dd15102.kasserver.com/mysqladmin
* User: d015dedf
* Pass: QUtNzpy3QF25gv3E

Temporary DB
------------
__This DB is deleted from time to time.__
* https://dd15102.kasserver.com/mysqladmin
* User: d0161511
* Pass: nmsN8dCS5yB3mFUk

API methods
-----------
https://github.com/fjenett/piecemaker/blob/master/app/controllers/api_controller.rb#L15


```
users
events
event_fields
event_groups

GET  /users
POST /user
GET  /user/:id
PUT  /user/:id
DEL  /user/:id

GET  /user/:id/events
GET  /user/:id/event_groups

GET  /events
POST /event
GET  /event/:id (with event_group and created_by_user and fields)
PUT  /event/:id
DEL  /event/:id

(GET  /event/:id/fields)
GET  /event/:id/field/:key
POST /event/:id/field
PUT  /event/:id/field/:key
DEL  /event/:id/field/:key

GET  /event_groups
GET  /event_group/:id
POST /event_group
PUT  /event_group/:id
DEL  /event_group/:id
```