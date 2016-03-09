#!/bin/sh
alias luarocks-5.1="lua5.1 /usr/bin/luarocks --local"
alias luarocks-5.2="lua5.2 /usr/bin/luarocks --local"
alias luarocks-5.3="lua5.3 /usr/bin/luarocks --local"
# In *reverse* order of PATH preference
eval `lua5.1 /usr/bin/luarocks --bin path`
eval `lua5.2 /usr/bin/luarocks --bin path`
eval `lua5.3 /usr/bin/luarocks --bin path`
