local assert = require('assert')
local fork = require('fork')
local exit = require('exit')
local gcfn = require('gcfn')
local pipe = require('os.pipe')
local reader, writer = assert(pipe())

-- test that exit with status 0 if no argument
local p = assert(fork())
if p:is_child() then
    local _ = gcfn(function()
        writer:write('exit on gc')
    end)
    exit()
end
local res = p:wait()
assert.equal(res.exit, 0)
assert.equal(reader:read(), 'exit on gc')

-- test that exit with status 0 if argument is true
p = assert(fork())
if p:is_child() then
    exit(true)
end
res = p:wait()
assert.equal(res.exit, 0)

-- test that exit with status 1 if argument is true
p = assert(fork())
if p:is_child() then
    exit(false)
end
res = p:wait()
assert.equal(res.exit, 1)

-- test that exit with status 123 if argument is 123
p = assert(fork())
if p:is_child() then
    exit(123)
end
res = p:wait()
assert.equal(res.exit, 123)

-- test that exit with status 255 if argument is -1
p = assert(fork())
if p:is_child() then
    exit(-1)
end
res = p:wait()
assert.equal(res.exit, 255)
