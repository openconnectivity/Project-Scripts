<<<<<<< HEAD
# Scripts for OCF Project Development
=======
# Project Development Scripts
>>>>>>> origin/master

This repository contains scripts for creating OCF projects in any directory using either IoTivity or IoTivity-lite.

# Installation

<<<<<<< HEAD
To install all the samples described above, just type the following command.
=======
To install all the scripts described above, just type the following command.

- curl https://openconnectivity.github.io/Project-Scripts/install.sh | bash

This command will do a number of things:

- Clone the Sample-Raspberry-Pi-Code repository (which includes all the sample code described above). Each sample subdirectory includes the following files:
  - SConscript: A scons description file that will manage the compiling and linking of the project.
  - <sample>.json: The JSON device description file that is the input to DeviceBuilder and describes all the resources available on the device. Each of these resources will show up in the source code and introspection file created by DeviceBuilder.
  - <sample>.cpp: The C++ code that includes all the resources plus the code to interface to the hardware. This code can be copied over the C++ code created by DeviceBuilder when the gen.sh script is run in order to control the hardware. If you run gen.sh again, <sample>.cpp will be overwritten. So if you change anything in <sample>.cpp, be sure to make a backup or avoid running gen.sh again. Otherwise, you will lose your work.
  - <sample>.py: The Python code that connects the C++ code to the Pimoroni python libraries. This code will be copied to the executable directory so it will be available at runtime to control the hardware.
>>>>>>> origin/master

- curl https://openconnectivity.github.io/Project-Scripts/install.sh | bash

Some environment variables may need to be updated. When the curl command is run, the ~/.bashrc file will be modified so that these envorinment variables are set on bootup. The system will need ~/.bashrc to be run. The following command should do it.
- source ~/.bashrc

# Building and Running the samples

A number of convenience scripts have been written to make the development cycle easier.
1. Run the following development cycle as needed
    1. create_project project_name - create a new project and name it anything you want.
    2. This isn't a script, but you need to "cd project_name" to run all the other scripts.
    3. Copy the setup.sh from the Emulator-Code/emulator/dimlight/ directory to the current project directory
    4. ./setup.sh - This will load all the necessary stuff to build and run the sample emulator project.
    5. edit_input2.sh - edit the device description input file (<project name>.json) if necessary.
    6. gen2.sh - generate the code, introspection file, PICS file, and onboarding file from the device description file.
    7. build2.sh - compile and link everything
    8. edit_code2.sh - edit the server source code if necessary.
    9. reset2.sh - reset the sever to RFOTM by copying a fresh onboarding file
    10. run2.sh - run the currently compiled server in the appropriate directory
2. To test the project, you will need to run a client. Here are some options.
    1. Discover, onboard and control the server using OTGC
    2. Discover, onboard and control the server using DeviceSpy
    3. Test the server using CTT
