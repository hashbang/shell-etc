alias luarocks-5.1="lua5.1 /usr/bin/luarocks --local"
alias luarocks-5.2="lua5.2 /usr/bin/luarocks --local"
alias luarocks-5.3="lua5.3 /usr/bin/luarocks --local"
eval `lua5.3 /usr/bin/luarocks path`
eval `lua5.2 /usr/bin/luarocks path`
eval `lua5.1 /usr/bin/luarocks path`
# always do 5.1 last

