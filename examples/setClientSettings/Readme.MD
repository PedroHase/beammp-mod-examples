# setClientSettings Example

| **Source**      | https://discord.com/channels/601558901657305098/749321846763290676/1047898644218658866 |
|-----------------|----------------------------------------------------------------------------------------|
| **Author**      | https://github.com/StanleyDudek                                                        |
| **Type**        | Client                                                                                 |
| **Description** | Example of how to block client inputs (e.g. world editor & console, etc)               |

## Code Examples

### Setting settings for client

```lua
--gravity
core_environment.getGravity() --default -9.81
core_environment.setGravity(number)
--sim speed
be:getSimulationTimeScale() --default 1
be:setSimulationTimeScale(number)
-- simplified physics
settings.getValue('disableDynamicCollision') --true or false, this is read from the client's settings
be:setDynamicCollisionEnabled(boolean) --this does not change their settings, only applies to active session
```

### Check if client settings are not changed

This can help catch trolls

```lua
if core_environment.getGravity() ~= -9.81 then
  --tell server to kick player or force -9.81 or whatever you want
end
if be:getSimulationTimeScale() ~= 1 then
  --tell server to kick player or force 1 or whatever you want
end
be:setDynamicCollisionEnabled(false)
```

> you could do this when they join, or have a periodic check to see if they've changed a setting, etc
This path leads to server control of clients' entire environment and simulation if you are interested
That is, gravity, sim speed, temperature, sun, time, weather, and so on

\- [@Dudekahedron [⭔¹²]](https://discord.com/channels/601558901657305098/749321846763290676/1047900226628882482)