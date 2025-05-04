mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
  CREATE USER 'goosetunetv'@'%' IDENTIFIED BY '${MYSQL_GOOSETUNETV_PASSWORD}';
  GRANT ALL ON goosetunetv_test.* TO 'goosetunetv'@'%';
  GRANT ALL ON goosetunetv_development.* TO 'goosetunetv'@'%';
  FLUSH PRIVILEGES;
EOF
