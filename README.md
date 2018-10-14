# Scripts for OCF Project Development

This repository contains scripts for creating OCF projects in any directory using either IoTivity or IoTivity-lite.

# Installation

To install all the scripts described above, just type the following command.

- curl https://openconnectivity.github.io/Project-Scripts/install.sh | bash

# Setting the PATH to find the Scripts

The scripts are normally stored in the Project-Scripts directory under the HOME directory, but just add the Project-Scripts directory to the PATH. The ~/.bashrc file should have been modified provide the correct path every time you log in, but to get the PATH fixed immediately, the following command should do it:

- source ~/.bashrc

This should also work:

- cd ~/Project-Scripts
- source ./set_path.sh

# Building and Running Projects

With the PATH set, the following tool chain should work.

A number of convenience scripts have been written to make the development cycle easier.
1. Run the following development cycle as needed
    1. create_project project_name - Create a new project in a new directory directly under the current directory (working in a development directory (e.g. cd ~/workspace) is a good way to organize projects) and name it anything you want.
    2. This isn't a script, but you need to "cd project_name" to run all the other scripts.
    3. (optional) Copy the setup.sh from the directory of the sample you want to install into the current project directory.
    4. (optional) ./setup.sh - This will load all the necessary stuff to build and run the particular sample project.
    5. edit_config.sh - Edit the project configuration file (project_name-config.json) if necessary. (e.g. to change the IoTivity version or target OS). NOTE: Temporarily, only the first entry in the configuration implementation and platform arrays is used.
    6. edit_input.sh - Edit the input file (e.g. example.json). This is for convenience only as the input file is simply created from the config file.
    7. gen.sh - Generate the code, introspection file, PICS file, and onboarding file from the device description file. The IoTivity version specified in the config file will be used.
    8. build.sh - Compile and link everything. The IoTivity version in the config file will be used.
    9. edit_code.sh - Edit the server source code if necessary.
    10. reset.sh - Reset the sever to RFOTM.
    11. run.sh - Run the currently compiled server in the appropriate directory.
2. To test the project, you will need to run a client. Here are some options.
    1. Discover, onboard and control the server using OTGC.
    2. Discover, onboard and control the server using DeviceSpy.
    3. Test the server using CTT.
