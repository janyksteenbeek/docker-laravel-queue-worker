[supervisord]
nodaemon=true

[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/app/artisan queue:listen %%QUEUE_CONNECTION%% --queue=%%QUEUE_NAME%% --memory=%%MEMORY_LIMIT%%
autostart=true
autorestart=true
numprocs=10
startretries=10
stdout_events_enabled=1
