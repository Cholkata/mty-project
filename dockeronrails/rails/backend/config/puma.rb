max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
min_threads_count = max_threads_count
threads min_threads_count, max_threads_count

port ENV.fetch("PORT", 3000)
bind "tcp://0.0.0.0:#{ENV.fetch("PORT", 3000)}"
environment ENV.fetch("RAILS_ENV", "production")

workers Integer(ENV.fetch("WEB_CONCURRENCY", 1))

preload_app!

plugin :tmp_restart

