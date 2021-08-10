clearScreen.

set launchpadCoords to ship:geoposition.
set altOffset to 30.238.
lock g to constant:g * body:mass / body:radius^2.
lock trueRadar to alt:radar - altOffset.
lock maxDecel to (ship:availablethrust / ship:mass) - g.
lock stopDist to ship:verticalspeed^2 / (2 * maxDecel).
lock landing_throttle to stopDist / trueRadar.
lock impactTime to trueRadar / abs(ship:verticalspeed).


function ascent_steering{
    return up + r(0, -90 * ship:apoapsis / 100000, 0).
}

function boostback_steering{
    return up + r(0, 90, 0).
}

wait until ag9.

stage.

local all_engines is list().
list engines in all_engines.
set main_engine to all_engines[0].

for engine in all_engines{
    if engine:ignition{
        set main_engine to engine.
    }
}

wait until stage:ready.
lock throttle to 1.
lock steering to ascent_steering().
set runmode to 1.

set engineMode to 0.

function setEngineMode{
    parameter mode.
    if mode > 2 or mode < 0{
        return.
    }
    until engineMode = mode{
        toggle ag1.
        set engineMode to engineMode + 1.
        set engineMode to mod(engineMode, 3).
    }
}

until false{
    if runmode = 1{ // Ascent and gravity turn
        if stage:resourceslex["LiquidFuel"]:capacity <> 0 and stage:resourceslex["LiquidFuel"]:amount / stage:resourceslex["LiquidFuel"]:capacity < 0.20{
            rcs on.
            
            lock steering to boostback_steering().
            lock throttle to 0.
            wait 0.1.

            set runmode to 2.

            stage.
        }
    }
    if runmode = 2{
        if vectorAngle(ship:facing:forevector, (up + r(0, 90, 0)):forevector) < 5{
            setEngineMode(2).

            lock throttle to 1.
            wait 0.1.
            set runmode to 3.
        }
    }
    if runmode = 3{
        if addons:tr:impactpos:lng < launchpadCoords:lng{
            setEngineMode(1).

            lock throttle to 0.
            lock steering to up.
            
            wait 0.1.
            
            set runmode to 4.
        }
    }
    if runmode = 4{
        if ship:altitude < 40000{
            set runmode to 10.
            brakes on.
            lock steering to srfRetrograde.
        }
    }
    if runmode = 10{
        if trueRadar < stopDist * 1.5{
            lock throttle to landing_throttle.
            set runmode to 11.
        }
    }
    if runmode = 11{
        if landing_throttle < 0.7{
            lock throttle to 0.
            wait 0.1.

            set runmode to 12.
        }
    }
    if runmode = 12{
        if trueRadar < stopDist * 0.75{
            lock throttle to landing_throttle.
            set runmode to 13.
        }
    }
    if runmode = 13{
        if impactTime < 3{
            gear on.
            set runmode to 14.
        }
    }
    if runmode = 14{
        if ship:verticalSpeed > -0.1{
            lock throttle to 0.
            lock steering to up.
            set runmode to 20.
        }
    }

    if runmode = 20{
        break.
    }
}

unlock throttle.
unlock steering.
rcs off.