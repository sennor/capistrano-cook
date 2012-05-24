Capistrano::Configuration.instance.load do
  set_default(:nginx_template) { "nginx_unicorn.erb" }
  set_default(:http_server, :nginx)

  namespace :nginx do
    task :install, roles: :web do
      run "#{sudo} add-apt-repository -y ppa:nginx/stable"
      run "#{sudo} apt-get -y update "
      run "#{sudo} apt-get -y install nginx"
      start
    end

    task :setup, roles: :web do
      template nginx_template, "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      reload
    end

    %w[start stop restart reload].each do |command|
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end

    if http_server == :nginx
      after "deploy:install",     "nginx:install"
      after "deploy:setup",       "nginx:setup"
      after "deploy:update_code", "nginx:setup"
    end
  end
end
