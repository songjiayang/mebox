set :stage, :production

server 'mebox.zuoyouba.com', user: 'deploy', roles: %w{web app db}
