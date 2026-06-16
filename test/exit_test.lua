local testcase = require('testcase')
local assert = require('assert')
require('exit')

-- Build a child Lua command that loads the exit module and invokes it
-- with the given snippet, then run it with os.execute and return (ok, exit_code).
local function run_child(snippet)
    local cmd = string.format("lua -e 'local exit = require(\"exit\"); %s'",
                              snippet)
    local ok, _, code = os.execute(cmd)
    -- on Lua 5.1, os.execute returns just the status code
    if type(ok) == 'number' then
        return ok == 0, ok
    end
    -- on Lua 5.2+, returns (true|nil|false, "exit"|"signal", code)
    return ok == true, code
end

function testcase.exit_returns_zero_with_no_argument()
    local _, code = run_child('exit()')
    assert.equal(code, 0)
end

function testcase.exit_with_true_returns_zero()
    local _, code = run_child('exit(true)')
    assert.equal(code, 0)
end

function testcase.exit_with_false_returns_one()
    local _, code = run_child('exit(false)')
    assert.equal(code, 1)
end

function testcase.exit_with_explicit_status_code()
    local _, code = run_child('exit(123)')
    assert.equal(code, 123)
end

function testcase.exit_with_invalid_argument_throws()
    -- a string argument is not accepted; lua errors out with non-zero status
    local ok, code = run_child('exit("bad")')
    assert.is_false(ok)
    assert.not_equal(code, 0)
end

function testcase.exit_runs_finalizers_via_lua_close()
    -- Use a temporary file to verify that Lua finalizers fire before the
    -- process actually exits.
    local tmp = os.tmpname()
    local snippet = string.format('local f = assert(io.open(%q, "w")); ' ..
                                      'setmetatable({}, {__gc = function() f:write("byebye"); f:close() end}); ' ..
                                      '_G._keep = setmetatable({}, getmetatable({})); ' ..
                                      'exit(0)', tmp)
    local _, code = run_child(snippet)
    assert.equal(code, 0)
    local fh = assert(io.open(tmp, 'r'))
    local content = fh:read('*a')
    fh:close()
    os.remove(tmp)
    assert.equal(content, 'byebye')
end
