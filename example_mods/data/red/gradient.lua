--- CUSTOMIZATION

local gradient = {
    direction = 'DOWN',
    color1 = 0xFFD20000,
    color2 = 0xFFFF0000,
    tweenDuration = 3
}
local particles = {
    direction = 'UP',
    color1 = 0xFFD20000,
    color2 = 0xFFFF0000,
    amount = 6,
    lifespan = 3
}

--- ONLY EDIT IF NEEDED

local Sprite = require 'cherlex.Sprite'
local TypedGroup = require 'cherlex.groups.TypedGroup'
local Particle = require 'cherlex.effects.Particle'
local Point = require 'cherlex.math.Point'
local Tween = require 'cherlex.tweens.Tween'
local Type = require 'cherlex.tweens.Type'
local Ease = require 'cherlex.tweens.Ease'
local Color = require 'cherlex.util.Color'

local typed = TypedGroup()
local grad

--This script is OUT OF COMMISSION LMAO
--Once i got it working my pc literally exploded, shriveled up, wilted, imploded, bamboozled, and died.
--Not to be used for a very long time lol
function onCreate()
    close(true);
end

function onStepHit()
    if curStep == 1088 then
        luaDebugMode = true
        grad = Sprite().makeGraphic(screenWidth, screenHeight, 0x00)
        grad.camera = 'other' --fuck you cherlex i dont want it above the hud
        grad.scrollFactor.x, grad.scrollFactor.y = 0, 0
        grad.add(true)
        grad.drawGradient(screenWidth, screenHeight, {0x00, 0xFFffffff}, 1, 90 * (gradient.direction == 'DOWN' and 1 or -1))
        Tween.color(grad, gradient.color1, gradient.color2, gradient.tweenDuration, {type = Type.PINGPONG, ease = Ease.expoOut})
        grad.blend = 'ADD'
        runTimer('ab', 3)
    end
end

function onTimerCompleted(t)
    if t == 'ab' then
        generateParticle()
        runTimer('ab', 3)
    end
end

function onUpdatePost(el)
    luaDebugMode = true
    if keyboardJustPressed 'P' then
        generateParticle()
    end
end

-- Generate a particle
function generateParticle()
    for i = 1, 5 do
        -- Set the particle size
        local size = getRandomInt(20, 100)
        local scale = getRandomFloat(0.5, 1.0)

        -- Create the particle
        local particle = Particle((screenWidth/5)*i-size*2)
        typed.add(particle, true)
        particle.makeGraphic(size, size, 0xFFffffff)

        -- Set particle properties
        local y = particles.direction == 'DOWN' and 0 or screenHeight
        local drag = 0
        local numWaves = getRandomInt(1, 4)
        for j = 1, numWaves do
            local amplitude = getRandomInt(50, 100)
            local frequency = getRandomInt(2, 5)
            local phase = getRandomFloat(0, math.pi)
            local sign = (j % 2 == 0) and -1 or 1
            y = y - sign * amplitude * math.sin(frequency * (i-1) * (screenWidth/5) + size/2 + phase)
            drag = drag + sign * amplitude * math.sin(frequency * (particle.x + phase))
            drag = drag + math.sin(particle.y / (screenHeight * 0.5)) * (amplitude * 0.5)

            local dirA = particles.direction == 'UP' and -1 or 1
            particle.velocityRange.fin = (Point(0, getRandomInt(300*dirA, 500*dirA)) + Point(math.sin(particle.y / (screenHeight * 0.5)) * 50, 0))
            particle.accelerationRange.fin = Point(0, getRandomInt(-100, -200)).scale(dirA)
            particle.scaleRange.fin = Point(scale, scale) + Point(math.sin(particle.y / screenHeight) * 0.1, math.sin(particle.y / screenHeight) * 0.1)
        end
        
        -- Add more aesthetic y movements
        y = y - math.abs(math.sin(particle.x/100) * 200) -- adds some small undulations
        y = y + math.cos((particle.x/2) + math.pi) * 50 -- creates a larger wave that oscillates
        y = y + math.sin((particle.x/5) + math.pi/2) * 25 -- creates a smaller wave that moves up and down quickly
        y = y + math.sin((particle.x/20) + math.pi/4) * 10 -- creates a small wave that moves up and down slowly

        
        particle.y = y
        particle.lifespan = particles.lifespan
        particle.alphaRange.fin = 0
        particle.angularVelocityRange.fin = math.random(-300, 360) * math.random(-1, 1)
        particle.colorRange.start = particles.color1
        particle.colorRange.fin = particles.color2
        particle.blend = 'ADD'
        particle.dragRange = Point(drag, drag)
        particle.autoUpdateHitbox = true
        particle.camera = 'other'

        -- Remove particle when killed
        particle.onKill = function (t)
            typed.remove(t, true)
            t.destroy()
        end

        -- Set scroll factor to make the particles appear fixed on screen
        particle.scrollFactor.x = 0
        particle.scrollFactor.y = 0

        -- Set rotation to add some variety to the particles
        particle.angle = getRandomInt(30, 70)
        
        
        -- Add a bouncing effect to the particle
        particle.elasticity = 0.5
        
        grad.drawGradient(screenWidth, screenHeight, {0x00, 0xFFffffff}, 1, 90 * (gradient.direction == 'DOWN' and 1 or -1))
    end
end
