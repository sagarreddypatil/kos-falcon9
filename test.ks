clearScreen.
lock currentPitch TO 90 - VECTORANGLE(UP:VECTOR, SHIP:FOREVECTOR).
lock currentRoll to VECTORANGLE(UP:VECTOR,SHIP:STARVECTOR).
lock currentYaw to ship:bearing.


until false{
    clearScreen.
    print currentPitch at (0, 0).
    print currentYaw at (0, 1).
    print currentRoll at (0, 2).
}