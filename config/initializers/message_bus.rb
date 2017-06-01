MessageBus.configure(backend: :memory)

MessageBus.user_id_lookup do |env|
  req = Rack::Request.new(env)
  if req.session && req.session["user_id"]
    req.session["user_id"]
  end
end
