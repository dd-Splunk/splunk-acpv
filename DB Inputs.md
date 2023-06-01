# DB Inputs

Config file: db_inputs.conf

```
[rising-assets]
connection = splunkdb-cmdb1
disabled = 0
index = assets
index_time_mode = current
interval = */1 * * * *
mode = rising
query = SELECT * FROM `splunkdb`.`asset`\
WHERE id >?\
ORDER BY id ASC
sourcetype = acpv:asset
tail_rising_column_init_ckpt_value = {"value":"0","columnType":3}
tail_rising_column_name = id
tail_rising_column_number = 1
```
