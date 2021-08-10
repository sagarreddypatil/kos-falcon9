// Copy this file to boot/filename.ks and connect it to the ship
copyPath("0:/kos-landing/main.ks", "1:/").
copyPath("0:/kos-landing/test.ks", "1:/").

print "Press Any Key to Start Script".

run main.ks.