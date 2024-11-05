// creation of initial user
use integrator;
db.createUser({
   user: "admin",
   pwd: "admin",
   roles: [ "readWrite", "dbAdmin" ]
});
