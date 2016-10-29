#!/bin/sh
alias luarocks-5.1="lua5.1 /usr/bin/luarocks --local"
alias luarocks-5.2="lua5.2 /usr/bin/luarocks --local"
alias luarocks-5.3="lua5.3 /usr/bin/luarocks --local"
# Need to do 5.1 last, as it adds to LUA_PATH, which would be picked up by the other commands
eval `lua5.3 /usr/bin/luarocks --bin path`
eval `lua5.2 /usr/bin/luarocks --bin path`
eval `lua5.1 /usr/bin/luarocks --bin path`
