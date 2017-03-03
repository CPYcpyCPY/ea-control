# 从test-plan对象中parse出steps信息，供execution detail页面使用
# 将被ea-control server使用，browser给出test-plan，然后server解析

require! './test-plan-loader'

HUMAN_TASK_TIME = 5m * 60s * 1000ms

module.exports =
  get-test-info: (test, cb)-> test-plan-loader.load test, ({plan})~>
    # console.log "test-plan: ", plan
    cb info =
      steps: steps = [@get-step-info step for step in plan.steps]

  get-step-info: (step)-> 
    id: step.id
    name: step.name
    type: step.type
    estimate-execution-time: @calculate-estimate-execution-time step
    next: if !step.branches then [@get-next-step-id step] else @get-next-steps-ids step

  calculate-estimate-execution-time: (step)-> 
    switch step.type
      | 'human' => HUMAN_TASK_TIME
      | 'parallel' => Math.max.apply null, [@calculate-estimate-execution-time child-step for child-step in step.child-steps]
      | otherwise => step.hold-time or 0

  get-next-step-id: (step)->
    return step.id + 1 if !step.next
    step.next!

  get-next-steps-ids: (step)-> 
    [get-branch-next-step-id branch, step for branch in step.branches]

  get-branch-next-step-id: (branch, step)->
    step.current-branch = branch
    step.next!


