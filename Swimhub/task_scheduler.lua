local task_scheduler = {}
do
    local _tasks = {}
    local function check_tasks(task)
        for _, microtask in task["tasks"] do
            if not microtask.done then return false end
        end
        return true
    end
    function task_scheduler:new(name, tasktable)
        if type(name) ~= "string" then
            return print("task_scheduler: no valid name provided (new)\n"..debug.traceback())
        end
        if type(tasktable) ~= "table" then
            return print("task_scheduler: no valid task table provided (new)\n"..debug.traceback())
        end
        if _tasks[name] then
            return print("task_scheduler: error, task with the same name is running (new)\n"..name, "\n"..debug.traceback())
        end

        _tasks[name] = {
            ["started"] = false,
            ["started-at"] = 0,
            ["ended"] = false,
            ["ended-at"] = 0,
            ["tasks"] = {}
        }

        local _task = _tasks[name]

        function _task:check()
            return check_tasks(_task)
        end

        function _task:start()
            if _task["started"] then
                return print(`task_scheduler: task already started ({name}) (new, start)\n`..debug.traceback())
            end
            if _task["ended"] then
                return print(`task_scheduler: task already ended ({name}) (new, start)\n`..debug.traceback())
            end
            _task["started"] = true
            _task["started-at"] = tick()
            for _, microtask in _task["tasks"] do
                coroutine.resume(microtask["thread"])
            end
            repeat task.wait() until _task:check()
            _task["ended"] = true
            _task["ended-at"] = tick()
            return _task, _task["ended-at"] - _task["started-at"]
        end

        function _task:terminate()
            _tasks[name] = nil
        end

        for index, func in tasktable do
            if type(func) ~= "function" then
                return print(`task_scheduler: not a function at index {index} (new)\n`..debug.traceback())
            end

            local microtask = {
                ["done"] = false,
                ["_parent_task"] = _task
            }

            local thread = coroutine.create(function()
                func()
                microtask.done = true
            end)

            microtask["thread"] = thread

            _task["tasks"][index] = microtask
        end
        return _task
    end
end
return task_scheduler
--[[
local wow_task = task_scheduler:new("long boring task", {
    function()
        task.wait(1)
    end,
    function()
        task.wait(2)
    end,
    function()
        task.wait(3)
    end
})
print(wow_task:start())
wow_task:terminate()
]]
