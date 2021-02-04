# Backend Database server
Based on [this blog post](https://blog.dbi-services.com/build-api-backend-server-with-nodejs-and-postgresql/) by Furkan Suv - September 2020

---
## Prerequisites

 - [**Mysql workbench community**](https://dev.mysql.com/downloads/workbench/)
   - configure with passwd: "changeme"
   - port: 3306
 - [**Mysql Server community**](https://dev.mysql.com/downloads/mysql/)
 - Add 'MySQL server' bin/ folder to your env variable 
   
## Creating Local database
1. Open Mysql workbench
2. Add a connection with settings:
   - **Port** : 3306
   - **host** : 127.0.0.1
   - **passwd**: changeme
3. Wihtin the connection: "connection"--> "advanced" --> "other" text bloc, add: `OPT_LOCAL_INFILE=1`
4. Test de connection
5. Open the connection 
6. File->Open SQL script->[ibusdb_creation_script.sql](ibusdb_creation_script.sql) 
7. Run the script
8. Run [load_data.bat](data_imports/load_data.bat) into data_imports/

That's it! The test database should now be ready to go.
You can play with it, insert and update for testing purposes.

**This is just a database made to allow the testing of the whole pipeline. It will be changed in the future**

## IBUStest Structure
![IBUSdb diagram](IBUSdb_diagram.png)

---
### TODO
 - Complete the real database
 - Complete the scripts to generate lots of fake data
 - add tests scripts to ensure the triggers work 