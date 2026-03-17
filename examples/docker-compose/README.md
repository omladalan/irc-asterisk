# Temporary documentation! / Documentação temporária!

I will write proper documentation for this project, but first I need to update `omladalan/irc-pgbouncer` to make the project elegant.

Irei escrever uma documentação digna para este projeto, mas antes preciso atualizar o `omladalan/irc-pgbouncer` para o projeto ficar elegante.

## Stack(Postgres 16, irc-pgbouncer and/e irc-asterisk)

It is necessary to give 1777 permission to the folder `./docker-compose-files/irc-pgbouncer` because I did not properly implement the socket permission in the image `omladalan/irc-pgbouncer`.

É necessário dar permissão 1777 para a pasta `./docker-compose-files/irc-pgbouncer` pois eu não implementei corretamente na imagem `omladalan/irc-pgbouncer` a permissão do socket.

```python
sudo chmod 1777 ./docker-compose-files/irc-pgbouncer
```
Configure the environment files `.env.asterisk`, `.env.pgbouncer`, and `.env.postgres`.

Configurar os arquivos de ambiente `.env.asterisk`, `.env.pgbouncer` e `.env.postgres`.


And finally, bring up the stack.

E por último subir a stack.

```python
docker compose up -d
```

Example SQL script to insert a dial plan and two extensions for testing.

Exemplo de script sql para inserir um dial plan e dois ramais para teste.

```python
insert into extensions_config (cat_metric, var_metric, commented, filename, category, var_name, var_val)
values(1, 1, 0,'extensions.conf', 'testing', 'exten', '_1XX,1,NoOp()'),
(1, 2, 0,'extensions.conf', 'testing', 'same', 'n,Dial(PJSIP/${EXTEN}, 20)');

insert into ps_transports (id, bind, protocol, tcp_keepalive_enable) values('transport-udp', '0.0.0.0', 'udp', null);

insert into ps_aors (id, max_contacts, remove_existing) values (101, 1, 'yes');
insert into ps_aors (id, max_contacts, remove_existing) values (102, 1, 'yes');

insert into ps_auths (id, auth_type, password, username) values (101, 'userpass', '101', 101);
insert into ps_auths (id, auth_type, password, username) values (102, 'userpass', '102', 102);

insert into ps_endpoints (id, transport, aors, auth, context, disallow, allow, direct_media, dtmf_mode, callerid, trust_id_outbound) values (101, 'transport-udp', '101', '101', 'testing', 'all', 'ulaw', 'no', 'rfc4733', '101 <101>', 'yes');
insert into ps_endpoints (id, transport, aors, auth, context, disallow, allow, direct_media, dtmf_mode, callerid, trust_id_outbound) values (102, 'transport-udp', '102', '102', 'testing', 'all', 'ulaw', 'no', 'rfc4733', '102 <102>', 'yes');
```