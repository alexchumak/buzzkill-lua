local moduleName = ...

local tones = {
  a = 440,
  A = 800,
  b = 493,
  c = 261,
  C = 523,
  d = 294,
  e = 329,
  E = 659,
  f = 349,
  g = 392,
}

local function note_end(pin, callback)
  pwm.stop(pin)

  if callback then
    callback()
  end
end

local function note_start(pin, frequency, duration, callback)
  pwm.setup(pin, frequency, 512)
  pwm.start(pin)

  tmr.create():alarm(duration, tmr.ALARM_SINGLE, function() note_end(pin, callback) end)
end

local function play_notes(pin, list, callback, delay)
  local functions = {}
  local index = 1

  delay = delay or 10

  for i=table.getn(list), 1, -1 do
    local hash = list[i]

    functions[i] = function()
      tmr.create():alarm(delay, tmr.ALARM_SINGLE, function()
        local frequency = hash['frequency'] or tones[hash['note']]
        note_start(pin, frequency, hash['duration'], functions[i + 1] or callback)
      end)
    end
  end

  functions[1]()
end


local function create(pin)
  gpio.mode(pin, gpio.OUTPUT)
  gpio.write(pin, gpio.LOW)

  return function(notes, callback, delay) play_notes(pin, notes, callback, delay) end
end

local M = { setup = create, play = play_notes, playNote = function(pin, note, callback) play_notes(pin, { note }, callback) end }

_G[moduleName] = M

return M
