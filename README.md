# AMS Cache test example using Memcached / Dalli Store 

## Running the services

* Postgresql:5432
* Memcached:11211


### Running rails

1. `rails db:create`
2. `rails db:migrate && rails db:seed`
3. `rails server`
4. To get a user record run `curl -X GET localhost:3000/users/1`

## Caching Results

| Run           | Caching? | Response - ActiveModelSerializers::Adapter::Attributes | Total  |
| ------------- |:-------------:| -----:|-----:|
| First Run w/Cache Miss    | Yes | 43.1ms | 69ms |
| Second Run w/Cache Hit    | Yes | 42.67ms | 70ms |
| Third Run w/Cache Hit    | Yes | 10.31ms | 13ms |
| Forth Run w/Cache Hit    | Yes | 9.84ms | 12ms |
| Fifth Run w/o Caching    | No | 7.88ms | 11ms |
| Sixth Run w/o Caching    | No | 7.02ms | 9ms |


### Raw Output
#### First Run w/Cache Miss 
```
Started GET "/users/1" 
  ActiveRecord::SchemaMigration Load (0.7ms)  SELECT "schema_migrations".* FROM "schema_migrations"
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers] Cache read: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers] Dalli::Server#connect 127.0.0.1:11211
[active_model_serializers] Cache generate: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers] Cache write: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers]   Organization Load (1.3ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Cache read: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Cache generate: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Cache write: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (43.1ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":true},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 69ms (Views: 42.9ms | ActiveRecord: 12.7ms)
```
#### Second Run w/Cache hit 

```
Started GET "/users/1" 
  ActiveRecord::SchemaMigration Load (0.7ms)  SELECT "schema_migrations".* FROM "schema_migrations"
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers] Cache read: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers] Dalli::Server#connect 127.0.0.1:11211
[active_model_serializers] Cache fetch_hit: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers]   Organization Load (1.3ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Cache read: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Cache fetch_hit: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (42.67ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":true},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 70ms (Views: 42.6ms | ActiveRecord: 12.6ms)
```

#### Third Run w/Cache hit 

```
Started GET "/users/1"
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers] Cache read: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers] Cache fetch_hit: users/1-20170423163809196197/attributes/adcc32fd6ac06e7f189307a4bf1300e2
[active_model_serializers]   Organization Load (0.8ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Cache read: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Cache fetch_hit: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (10.31ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":true},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 13ms (Views: 10.4ms | ActiveRecord: 1.5ms)
```

#### Fourth Run w/Cache hit 
```
Started GET "/users/1" 
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers] Cache read: users/1-20170423164344556799/attributes/775ab5b5145840b05663a0286281daa9 ({:expires_in=>60 minutes})
[active_model_serializers] Cache fetch_hit: users/1-20170423164344556799/attributes/775ab5b5145840b05663a0286281daa9 ({:expires_in=>60 minutes})
[active_model_serializers]   Organization Load (0.8ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Cache read: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Cache fetch_hit: organizations/1-20170423163809152527/attributes/a74db0c5f71a4f9513eb81e760b03d2c ({:expires_in=>60 minutes})
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (9.84ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":true},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 12ms (Views: 9.8ms | ActiveRecord: 1.3ms)
```

#### No Caching - First Run 
```
Started GET "/users/1"
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers]   Organization Load (0.8ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (7.88ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":false},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 11ms (Views: 8.0ms | ActiveRecord: 1.5ms)
```
#### No Caching - Second Run 
```
Started GET "/users/1"
Processing by UsersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
[active_model_serializers]   Organization Load (0.7ms)  SELECT "organizations".* FROM "organizations" INNER JOIN "memberships" ON "organizations"."id" = "memberships"."organization_id" WHERE "memberships"."user_id" = 1 ORDER BY "organizations"."name" ASC
[active_model_serializers] Rendered UserSerializer with ActiveModelSerializers::Adapter::Attributes (7.02ms)
{"ams_config":{"cache_store":true,"perform_caching":true},"serializers_config":{"UserSerializer_caching":false},"app_config":{"cache_store":true,"perform_caching":true}}
Completed 200 OK in 9ms (Views: 6.9ms | ActiveRecord: 1.3ms)
```


