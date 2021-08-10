clearScreen.

set launchpadCoords to ship:geoposition.
set altOffset to alt:radar.
lock g to constant:g * body:mass / body:radius^2.

set steer to up.
set thrott to 0.

wait until ag9.

stage.
wait until stage:ready.
lock throttle to thrott.
lock steering to steer.
//stage.
//wait until stage:ready.
set runmode to 1.


until false{
    if runmode = 1{ // Ascent and gravity turn
        lock throttle to 1.
        lock steering to up + r(0, -90 * ship:apoapsis / 100000, 0).

        if stage:resourceslex["LiquidFuel"]:capacity <> 0 and stage:resourceslex["LiquidFuel"]:amount / stage:resourceslex["LiquidFuel"]:capacity < 0.1{
            rcs on.
            lock throttle to 0.
            wait 0.5.

            set runmode to 2.

            stage.
            wait until stage:ready.
        }
    }
    if runmode = 2{
        lock throttle to 0.
        lock steering to up + r(0, 90, 0).
    }
}