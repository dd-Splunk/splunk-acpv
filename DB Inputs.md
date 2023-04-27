# DB Inputs

Config file: db_inputs.conf

```
[rising-assets]
connection = splunkdb-db
disabled = 0
index = main
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
checkpoint_key = 644a5010d1a05e3c19799182
```
