# This is a Script to install Simple Scalar on Ubuntu

For more information [SimpleScalar](http://www.simplescalar.com/) 

Simplescalar is pretty old so it has not being maintaned at all. This script allows it to be used for Educational purposes mainly.

The installation differs depending on your system : 32-bit / 64-bit.

To run just execute the correct script based on your system. Futhermore you might need to chmod the file. 

You might need to download the SimpleScalar simulator from the original website and save the .tar file inside the build folder.

## Instructions:

Use uname -i to determine the architecture.
I recommend using the 32 bit.

• Download the [simplesim-3v0e.tgz](http://www.simplescalar.com/agreement.php3?simplesim-3v0e.tgz) and move it to the /build folder
 
• chmod +x installscript_32.sh and execute
 
• The Global Variables need to be defaulted: **source ~/.bashrc**

## Test:

This is a crosscompiler necessary to run an application on the SimpleScalar simulator: sslittle-na-sstrix-gcc

Example is located inside the Test folder.

• Compile example: sslittle-na-sstrix-gcc -x c++ main.c -o main

• Execute example: ../build/simplesim-3.0/sim-safe main

• The SimpleSim Simulator is located: ../build/simplesim-3.0/

• To test the simulator in the simplesim-3.0 directory: ./sim-safe tests-alpha/bin/test-math or ./sim-safe tests-pisa/bin.little/test-math
